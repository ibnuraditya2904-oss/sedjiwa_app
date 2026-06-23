from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import Optional
from datetime import datetime
from uuid import UUID
from app.models.enum import UserRole
from app.models.user import User
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.dashboard.user_assmt_schemas import (
    DassDashboardResponse, DassHistoryListResponse, 
    DassAssessmentDetailResponse, DassAnswersResponse
)
from app.services.dashboard.user_assmt_services import UserDassDashboardService

user_assmt_router = APIRouter()

@user_assmt_router.get(
    "", 
    response_model=BaseResponse[DassDashboardResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_dass_dashboard_summary(
    graph_limit: int = Query(default=7, ge=3, le=10, description="Jumlah titik tes masa lalu untuk ditarik ke dalam grafik"),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserDassDashboardService(session)
    data = await service.get_dass_dashboard(user_uid=current_user.uid, graph_limit=graph_limit)
    return BaseResponse[DassDashboardResponse](
        message="Dashboard summary DASS-21 berhasil dimuat",
        data=data
    )


@user_assmt_router.get(
    "/history", 
    response_model=BaseResponse[DassHistoryListResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_dass_history_infinite(
    limit: int = Query(default=10, ge=1, le=20),
    cursor: Optional[datetime] = Query(default=None, description="Gunakan format timestamp ISO (YYYY-MM-DDTHH:MM:SS.mmmmmm)"),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserDassDashboardService(session)
    data_list, next_cursor = await service.get_dass_history_page(
        user_uid=current_user.uid, 
        limit=limit, 
        cursor=cursor
    )
    return BaseResponse[DassHistoryListResponse](
        message="Daftar riwayat tes berhasil dimuat",
        data=DassHistoryListResponse(data=data_list, next_cursor=next_cursor)
    )


@user_assmt_router.get(
    "/history/{result_uid}", 
    response_model=BaseResponse[DassAssessmentDetailResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_dass_detail_interpretation(
    result_uid: UUID,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserDassDashboardService(session)
    point= await service.get_assessment_detail(
        user_uid=current_user.uid, 
        result_uid=result_uid
    )
    
    response_data = DassAssessmentDetailResponse(
        uid=point.uid,
        session_uid=point.session_uid,
        tested_at=point.tested_at,
        depression=point.depression,
        anxiety=point.anxiety,
        stress=point.stress
    )
    return BaseResponse[DassAssessmentDetailResponse](
        message="Detail interpretasi klinis berhasil dimuat",
        data=response_data
    )


@user_assmt_router.get(
    "/history/{result_uid}/answers", 
    response_model=BaseResponse[DassAnswersResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_dass_reflective_answers(
    result_uid: UUID,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserDassDashboardService(session)
    res_uid,session_uid, tested_at, answers = await service.get_assessment_answers(
        user_uid=current_user.uid,
        result_uid=result_uid
    )
    
    response_data = DassAnswersResponse(
        uid=res_uid,
        session_uid=session_uid,
        tested_at=tested_at,
        answers=answers
    )
    return BaseResponse[DassAnswersResponse](
        message="Lembar refleksi jawaban berhasil dimuat",
        data=response_data
    )