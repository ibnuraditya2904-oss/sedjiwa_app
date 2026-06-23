from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.user import User, UserRole
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.admin.admin_recomm_schemas import (
    AdminRecommendationPaginatedResponse, AdminRecommendationStatsResponse
)
from app.services.admin.admin_recomm_services import AdminRecommendationService

admin_recommendation_router = APIRouter()

@admin_recommendation_router.get(
    "/stats",
    response_model=BaseResponse[AdminRecommendationStatsResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_recommendation_macro_stats(
    session: AsyncSession = Depends(get_session)
):
    service = AdminRecommendationService(session)
    data = await service.get_macro_recommendation_analytics()
    return BaseResponse[AdminRecommendationStatsResponse](
        message="Grafik analitik makro kepatuhan admin berhasil dimuat",
        data=data
    )


@admin_recommendation_router.get(
    "/users",
    response_model=BaseResponse[AdminRecommendationPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_users_compliance_anonymized(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    session: AsyncSession = Depends(get_session)
):
    service = AdminRecommendationService(session)
    data = await service.get_users_compliance_anonymized(page=page, limit=limit)
    return BaseResponse[AdminRecommendationPaginatedResponse](
        message="Master tabel kepatuhan versi anonim berhasil dimuat",
        data=data
    )