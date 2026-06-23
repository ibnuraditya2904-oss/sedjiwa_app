from uuid import UUID
from fastapi import APIRouter, Depends, Query, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.api.debs import  get_current_user, get_session, require_roles
from app.models.enum import UserRole
from app.models.user import User
from app.schemas.base import BaseResponse
from app.schemas.quest_schemas import PackageBulkCreate,  PackageResponse, PsychPackagePaginatedResponse, QuestionMinResponse, QuestionResponse, QuestionUpdate
from app.services.quest_services import QuestionService

psych_quest_router = APIRouter()

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

@psych_quest_router.get(
    "/all",
    response_model=BaseResponse[PsychPackagePaginatedResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def get_all_packages_for_psychologist(
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=10, ge=1, le=50),
    session: AsyncSession = Depends(get_session)
):
    service = QuestionService(session)
    data = await service.get_all_packages_for_psychologist(page=page, limit=limit)
    
    return BaseResponse[PsychPackagePaginatedResponse](
        message="Seluruh daftar paket kuesioner terpaginasi berhasil dimuat",
        data=data
    )


@psych_quest_router.post(
    "/package",
    response_model=BaseResponse[PackageResponse],
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def create_new_dass_package(
    payload: PackageBulkCreate,
    current_user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    service = QuestionService(session)
    new_pkg = await service.create_package_with_questions(data=payload, owner=current_user)
    return BaseResponse[PackageResponse](
        message="Paket instrumen baru berhasil didaftarkan",
        data=map_package_to_response(new_pkg)
    )


@psych_quest_router.post(
    "/package/{package_uid}/activate",
    response_model=BaseResponse[PackageResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def activate_dass_package(
    package_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = QuestionService(session)
    activated_pkg = await service.activate_package(package_uid=package_uid)
    return BaseResponse[PackageResponse](
        message="Paket kuesioner berhasil diaktifkan sebagai instrumen utama",
        data=map_package_to_response(activated_pkg)
    )


@psych_quest_router.patch(
    "/question/{question_uid}",
    response_model=BaseResponse[QuestionMinResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def update_question_text_content(
    question_uid: UUID,
    payload: QuestionUpdate,
    session: AsyncSession = Depends(get_session)
):
    service = QuestionService(session)
    updated_quest = await service.update_question_text(uid=question_uid, payload=payload)
    return BaseResponse[QuestionMinResponse](
        message="Redaksi kalimat butir soal berhasil diperbarui",
        data=QuestionMinResponse(
            question_uid=updated_quest.uid,
            question_text=updated_quest.question_text,
            question_number=updated_quest.question_number,
            dimension=updated_quest.dimension.value
        )
    )


@psych_quest_router.delete(
    "/package/{package_uid}",
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.psikolog]))]
)
async def delete_inactive_package(
    package_uid: UUID,
    session: AsyncSession = Depends(get_session)
):
    service = QuestionService(session)
    await service.delete_package(package_uid=package_uid)
    return BaseResponse[dict](
        message="Paket instrumen beserta seluruh butir soal di dalamnya berhasil dimusnahkan",
        data={}
    )