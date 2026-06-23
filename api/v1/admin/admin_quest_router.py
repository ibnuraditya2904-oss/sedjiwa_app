from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.api.debs import  get_current_user, get_session, require_roles
from app.models.enum import UserRole
from app.schemas.base import BaseResponse
from app.schemas.quest_schemas import PackageResponse
from app.services.quest_services import QuestionService

admin_quest_router = APIRouter()

def map_package_to_response(pkg: any) -> PackageResponse:
    return PackageResponse(
        package_uid=pkg.uid,
        title=pkg.title,
        is_active=pkg.is_active,
        created_by=pkg.created_by.name if pkg.created_by else "System",
        total_questions=len(pkg.questions),
        question_items=[{
            "question_uid": q.uid,
            "question_text": q.question_text,
            "question_number": q.question_number,
            "dimension": q.dimension.value
        } for q in sorted(pkg.questions, key=lambda x: x.question_number)]
    )

@admin_quest_router.get(
    "/active",
    response_model=BaseResponse[PackageResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.admin]))]
)
async def get_active_package_for_admin(session: AsyncSession = Depends(get_session)):
    service = QuestionService(session)
    package = await service.get_active_package()
    return BaseResponse[PackageResponse](
        message="Paket kuesioner aktif berhasil dimuat",
        data=map_package_to_response(package)
    )