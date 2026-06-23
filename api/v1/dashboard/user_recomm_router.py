from datetime import date
from typing import Optional
from fastapi import APIRouter, Depends, status, Query
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.models.user import User
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.dashboard.user_recomm_schemas import HistoryListResponse, RecommDashboardResponse, DailyChecklistHomeSummary, ActivityHomeSummary
from app.services.dashboard.user_recomm_services import UserRecommDashboardService

recomm_dash_router = APIRouter()

@recomm_dash_router.get(
    "/recommendation", 
    response_model=BaseResponse[RecommDashboardResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_recommendation_dashboard(
    limit_days: int = Query(default=2, ge=1, le=5),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserRecommDashboardService(session)
    today_tasks, stats, history, next_cursor = await service.get_recommendation_dashboard(
        user_uid=current_user.uid, 
        limit_days=limit_days
    )

    today_tasks_payload = []
    for dc in today_tasks:
        act_summary = None
        if dc.activity:
            act_summary = ActivityHomeSummary(
                uid=dc.activity_uid,
                title=dc.activity.title,
                duration=dc.activity.duration,
                intensity=dc.activity.intensity,
                activity_type=dc.activity.activity_type
            )
        today_tasks_payload.append(
            DailyChecklistHomeSummary(
                uid=dc.uid,
                slot_number=dc.slot_number,
                is_completed=dc.is_completed,
                activity=act_summary
            )
        )

    response_data = RecommDashboardResponse(
        today_tasks=today_tasks_payload,
        stats=stats,
        history=history,
        next_cursor=next_cursor
    )

    return BaseResponse[RecommDashboardResponse](
        message="Dashboard rekomendasi aktivitas berhasil dimuat",
        data=response_data
    )


@recomm_dash_router.get(
    "/recommendation/history", 
    response_model=BaseResponse[HistoryListResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_recommendation_history(
    limit_days: int = Query(default=5, ge=1, le=15),
    cursor: Optional[date] = Query(default=None, description="Masukkan nilai tanggal dari next_cursor sebelumnya"),
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = UserRecommDashboardService(session)
    history_list, next_cursor = await service.get_recommendation_history_page(
        user_uid=current_user.uid,
        limit_days=limit_days,
        cursor_date=cursor
    )
    
    response_payload = HistoryListResponse(
        data=history_list,
        next_cursor=next_cursor
    )
    
    return BaseResponse[HistoryListResponse](
        message="Daftar riwayat aktivitas berhasil dimuat",
        data=response_payload
    )