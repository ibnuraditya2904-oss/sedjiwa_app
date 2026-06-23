from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.admin.admin_home_schemas import AdminHomeSummaryResponse
from app.schemas.base import BaseResponse
from app.services.admin.admin_home_services import AdminHomeService

admin_home_router = APIRouter()

@admin_home_router.get(
    "/summary",
    response_model=BaseResponse[AdminHomeSummaryResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_admin_dashboard_summary(
    session: AsyncSession = Depends(get_session)
):
    service = AdminHomeService(session)
    data = await service.get_home_summary()
    
    return BaseResponse[AdminHomeSummaryResponse](
        message="Data summary dashboard admin berhasil dimuat",
        data=data
    )