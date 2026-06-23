from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Optional
from datetime import date
from uuid import UUID
from app.models.user import User, UserRole
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.admin.admin_assmt_schemas import AdminAssessmentDetailResponse, AdminAssessmentPaginatedResponse, AdminMacroStatsResponse
from app.schemas.base import BaseResponse
from app.services.admin.admin_assmt_services import AdminAssmtService


admin_assmt_router = APIRouter()


@admin_assmt_router.get(
    "/stats",
    response_model=BaseResponse[AdminMacroStatsResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_macro_bi_statistics(
    session: AsyncSession = Depends(get_session)
):
    service = AdminAssmtService(session)
    data = await service.get_macro_business_intelligence_stats()
    return BaseResponse[AdminMacroStatsResponse](
        message="Statistik diagram makro DASS-21 berhasil dimuat",
        data=data
    )


@admin_assmt_router.get(
    "",
    response_model=BaseResponse[AdminAssessmentPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_assessments_log_anonymized(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    sort: str = Query(default="DESC"),
    is_high_risk: Optional[bool] = Query(default=None),
    start_date: Optional[date] = Query(default=None),
    end_date: Optional[date] = Query(default=None),
    session: AsyncSession = Depends(get_session)
):
    service = AdminAssmtService(session)
    data = await service.get_assessments_log_anonymized(
        page=page, limit=limit, sort=sort, is_high_risk=is_high_risk,
        start_date=start_date, end_date=end_date
    )
    return BaseResponse[AdminAssessmentPaginatedResponse](
        message="Daftar log kuesioner versi anonim berhasil dimuat",
        data=data
    )


@admin_assmt_router.get(
    "/{result_uid}",
    response_model=BaseResponse[AdminAssessmentDetailResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_assessment_detail_anonymized(
    result_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = AdminAssmtService(session)
    data = await service.get_assessment_detail_anonymized(result_uid=result_uid)
    return BaseResponse[AdminAssessmentDetailResponse](
        message="Detail skor kuesioner versi anonim berhasil dimuat",
        data=data
    )