from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.models.user import User
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.dashboard.user_home_schemas import ActivityHomeSummary, DailyChecklistHomeSummary, HomeDashboardResponse, LatestAssessmentHomeSummary
from app.schemas.base import BaseResponse
from app.schemas.recomm_schemas import RecommendationPoolResponse
from app.services.dashboard.user_home_services import UserHomeDashboardService

user_dash_router = APIRouter()

@user_dash_router.get(
    "/home", 
    response_model=BaseResponse[HomeDashboardResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def get_home(
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    userdash_service = UserHomeDashboardService(session)

    dailychecklist, latestresult = await userdash_service.get_home_dashboard(current_user)
    
    dailychecklist_items = []
    for dc in dailychecklist:
        act_summary = None
        if dc.activity:
            act_summary = ActivityHomeSummary(
                uid=dc.activity_uid,
                title=dc.activity.title,
                duration=dc.activity.duration,
                intensity=dc.activity.intensity,
                activity_type=dc.activity.activity_type
            )
        
        dailychecklist_items.append(
            DailyChecklistHomeSummary(
                uid=dc.uid,
                slot_number=dc.slot_number,
                is_completed=dc.is_completed,
                activity=act_summary
            )
        )

    latestassmt = None
    if latestresult:
        latestassmt = LatestAssessmentHomeSummary(
            uid=latestresult.uid,
            depression_level=latestresult.depression_level,
            anxiety_level=latestresult.anxiety_level,
            stress_level=latestresult.stress_level,
            is_high_risk=latestresult.is_high_risk,
            created_at=latestresult.created_at
        )

    response_data = HomeDashboardResponse(
        user_name=current_user.name,
        today_tasks=dailychecklist_items,
        latest_assessment=latestassmt
    )

    return BaseResponse[HomeDashboardResponse](
        message="Data halaman utama berhasil dimuat",
        data=response_data
    )