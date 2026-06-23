from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Optional
from datetime import date
from uuid import UUID
from app.models.user import User, UserRole
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.psychologist.psycho_assmt_schemas import (
    PsychAssmtPaginatedResponse, PsychAssmtDetailResponse, PsychAnswersResponse,
)
from app.services.psychologist.psycho_assmt_services import PsychologistAssmtService


psych_assmt_router = APIRouter()

@psych_assmt_router.get(
    "",
    response_model=BaseResponse[PsychAssmtPaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_psychologist_assessments_log(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    sort: str = Query(default="DESC", description="Urutan tanggal tes: ASC atau DESC"),
    is_high_risk: Optional[bool] = Query(default=None, description="Filter kasus berisiko tinggi"),
    start_date: Optional[date] = Query(default=None, description="Format tanggal awal: YYYY-MM-DD"),
    end_date: Optional[date] = Query(default=None, description="Format tanggal akhir: YYYY-MM-DD"),
    search: Optional[str] = Query(default=None, description="Cari berdasarkan Nama atau Email Pasien"),
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistAssmtService(session)
    data = await service.get_assessments_log(
        page=page, limit=limit, sort=sort, is_high_risk=is_high_risk,
        start_date=start_date, end_date=end_date, search=search
    )
    return BaseResponse[PsychAssmtPaginatedResponse](
        message="Daftar log kuesioner psikolog berhasil dimuat",
        data=data
    )


@psych_assmt_router.get(
    "/{result_uid}",
    response_model=BaseResponse[PsychAssmtDetailResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_psychologist_assessment_detail(
    result_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistAssmtService(session)
    data = await service.get_assessment_detail(result_uid=result_uid)
    return BaseResponse[PsychAssmtDetailResponse](
        message="Detail hasil skor kuantitatif kuesioner berhasil dimuat",
        data=data
    )


@psych_assmt_router.get(
    "/{result_uid}/answers",
    response_model=BaseResponse[PsychAnswersResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_psychologist_user_answers_sheet(
    result_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistAssmtService(session)
    data = await service.get_user_answers_sheet(result_uid=result_uid)
    return BaseResponse[PsychAnswersResponse](
        message="Lembar jawaban refleksi pasien berhasil dimuat",
        data=data
    )