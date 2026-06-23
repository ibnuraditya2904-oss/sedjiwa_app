from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Optional
from uuid import UUID
from app.models.user import User, UserRole
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse

from app.schemas.psychologist.psycho_recomm_schemas import (
    PsychRecommendationPaginatedResponse, UserActivityDetailPaginatedResponse
)
from app.services.psychologist.psycho_recomm_services import PsychologistRecommendationService

psych_recommendation_router = APIRouter()


@psych_recommendation_router.get(
    "/users",
    response_model=BaseResponse[PsychRecommendationPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_psychologist_users_compliance_table(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    search: Optional[str] = Query(default=None, description="Cari nama atau email pasien"),
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistRecommendationService(session)
    data = await service.get_users_compliance_master_table(page=page, limit=limit, search=search)
    return BaseResponse[PsychRecommendationPaginatedResponse](
        message="Master tabel kepatuhan rekomendasi psikolog berhasil dimuat",
        data=data
    )


@psych_recommendation_router.get(
    "/users/{user_uid}/logs",
    response_model=BaseResponse[UserActivityDetailPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_user_activity_inner_logs(
    user_uid: UUID,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=50),
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistRecommendationService(session)
    data = await service.get_user_activity_logs_detail(user_uid=user_uid, page=page, limit=limit)
    return BaseResponse[UserActivityDetailPaginatedResponse](
        message="Detail log riwayat koping harian pasien berhasil dimuat",
        data=data
    )