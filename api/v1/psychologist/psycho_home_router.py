from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.models.user import User
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.base import BaseResponse
from app.schemas.psychologist.psycho_home_schemas import PsychologistHomeSummaryResponse
from app.services.psychologist.psycho_home_services import PsychologistHomeService


psy_home_router = APIRouter()

@psy_home_router.get(
    "/summary",
    response_model=BaseResponse[PsychologistHomeSummaryResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_psychologist_dashboard_summary(
    session: AsyncSession = Depends(get_session)
):
    service = PsychologistHomeService(session)
    data = await service.get_home_summary()
    
    return BaseResponse[PsychologistHomeSummaryResponse](
        message="Data summary dashboard psikolog berhasil dimuat",
        data=data
    )