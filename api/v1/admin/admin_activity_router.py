from fastapi import APIRouter, Depends, Query, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.schemas.base import BaseResponse
from app.schemas.activity_schemas import ActivityPaginatedResponse
from app.services.activity_services import ActivityService
from app.api.debs import  get_current_user, get_session, require_roles
from app.models.user import User


admin_activity_router = APIRouter()

@admin_activity_router.get(
    "",
    response_model=BaseResponse[ActivityPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_active_activities_for_admin(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    session: AsyncSession = Depends(get_session)
):
    service = ActivityService(session)
    data = await service.get_activities_for_admin(page=page, limit=limit)
    return BaseResponse[ActivityPaginatedResponse](
        message="Daftar aktivitas aktif berhasil dimuat",
        data=data
    )