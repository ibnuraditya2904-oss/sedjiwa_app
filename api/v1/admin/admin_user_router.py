from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Optional
from uuid import UUID
from app.models.user import UserRole
from app.api.debs import get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.admin.admin_user_schemas import AdminUserPaginatedResponse, AdminUserRowResponse, AdminUpdateUserRoleRequest
from app.services.user_services import UserService

admin_user_router = APIRouter()


@admin_user_router.get(
    "",
    response_model=BaseResponse[AdminUserPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_all_users_for_admin_management(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    search: Optional[str] = Query(default=None, description="Cari nama atau email pengguna"),
    role: Optional[UserRole] = Query(default=None, description="Filter berdasarkan peran spesifik"),
    is_active: Optional[bool] = Query(default=None, description="Filter akun aktif (true) atau soft-deleted (false)"),
    session: AsyncSession = Depends(get_session)
):
    service = UserService(session)
    data = await service.get_all_users_dashboard(
        page=page, limit=limit, search=search, role_filter=role, status_filter=is_active
    )
    return BaseResponse[AdminUserPaginatedResponse](
        message="Daftar manajemen pengguna berhasil dimuat",
        data=data
    )


@admin_user_router.patch(
    "/{user_uid}/role",
    response_model=BaseResponse[AdminUserRowResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def update_user_role_privilege(
    user_uid: UUID,
    payload: AdminUpdateUserRoleRequest,
    session: AsyncSession = Depends(get_session)
):
    service = UserService(session)
    data = await service.update_user_role_by_admin(user_uid=user_uid, new_role=payload.role)
    return BaseResponse[AdminUserRowResponse](
        message="Peran hak akses pengguna berhasil diperbarui",
        data=data
    )


@admin_user_router.delete(
    "/{user_uid}",
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def soft_delete_user_account(
    user_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = UserService(session)
    result = await service.soft_delete_user_by_admin(user_uid=user_uid)
    return BaseResponse[dict](
        message=f"Akun {result.name} berhasil dinonaktifkan",
        data=result
    )

@admin_user_router.post(
    "/{user_uid}/reactivate",
    response_model=BaseResponse[AdminUserRowResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def reactivate_user_account(
    user_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = UserService(session)
    data = await service.reactivate_user_by_admin(user_uid=user_uid)
    return BaseResponse[AdminUserRowResponse](
        message=f"Akun {data.name} berhasil diaktifkan kembali",
        data=data
    )