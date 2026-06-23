from uuid import UUID
from fastapi import APIRouter, Depends, Query, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.schemas.base import BaseResponse
from app.schemas.activity_schemas import ActivityCreate, ActivityPaginatedResponse, ActivityResponse, ActivityUpdate
from app.services.activity_services import ActivityService
from app.api.debs import  get_current_user, get_session, require_roles
from app.models.user import User


psych_activity_router = APIRouter()

@psych_activity_router.get(
    "/all",
    response_model=BaseResponse[ActivityPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_all_activities_for_psychologist(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    session: AsyncSession = Depends(get_session)
):
    service = ActivityService(session)
    data = await service.get_activities_for_psychologist(page=page, limit=limit)
    return BaseResponse[ActivityPaginatedResponse](
        message="Seluruh master data aktivitas terpaginasi berhasil dimuat",
        data=data
    )


@psych_activity_router.post(
    "/create",
    response_model=BaseResponse[ActivityResponse],
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def create_new_therapeutic_activity(
    payload: ActivityCreate,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = ActivityService(session)
    data = await service.create_activity(payload=payload, user=current_user)
    return BaseResponse[ActivityResponse](
        message="Aktivitas intervensi baru berhasil ditambahkan",
        data=data
    )


@psych_activity_router.patch(
    "/{activity_uid}",
    response_model=BaseResponse[ActivityResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def update_therapeutic_activity(
    activity_uid: UUID,
    payload: ActivityUpdate,
    session: AsyncSession = Depends(get_session)
):
    service = ActivityService(session)
    data = await service.update_activity(activity_uid=activity_uid, payload=payload)
    return BaseResponse[ActivityResponse](
        message="Detail data aktivitas berhasil diperbarui",
        data=data
    )


@psych_activity_router.delete(
    "/{activity_uid}",
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def delete_therapeutic_activity(
    activity_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = ActivityService(session)
    await service.delete_activity(activity_uid=activity_uid)
    return BaseResponse[dict](
        message="Aktivitas berhasil dimusnahkan secara permanen dari sistem",
        data={}
    )