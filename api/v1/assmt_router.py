import uuid
from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.models.user import User
from app.api.debs import get_current_user, get_session, require_roles
from app.schemas.assmt_schemas import AnswerData, AnswerSaveRequest, AssessmentResultResponse, AutoSaveResponse, QuestionData, StartAssessmentResponse, UserData
from app.schemas.base import BaseResponse
from app.services.assmt_services import AssessmentService


assmt_router = APIRouter()

@assmt_router.post(
    '/start', 
    response_model=BaseResponse[StartAssessmentResponse], 
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def start_assessment_endpoint(
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    
    service = AssessmentService(session)
    result, is_resume = await service.start_or_resume_assessment(current_user)
    
    answers_list = {a.question_uid: a for a in result.answers}

    questions_list = []
    for q in result.package.questions:
        saved_answer = answers_list.get(q.uid)

        answer_data = AnswerData(answer_score=saved_answer.answer_score) if saved_answer else None
        
        questions_list.append(
            QuestionData(
                uid=q.uid,
                question_number=q.question_number,
                question_text=q.question_text,
                answer=answer_data
            )
        )

    response_data = StartAssessmentResponse(
        session_uid=result.uid,
        package_title=result.package.title,
        is_resume=is_resume,
        started_at=result.started_at,
        questions=questions_list
    )

    return BaseResponse(
        message="Sesi tes dilanjutkan." if is_resume else "Sesi tes baru berhasil dimulai",
        data=response_data
    )

@assmt_router.put(
    '/{assmt_session_uid}/answers', 
    response_model=BaseResponse[AutoSaveResponse], 
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def auto_save_answer_endpoint(
    assmt_session_uid: uuid.UUID,
    payload: AnswerSaveRequest,
    session: AsyncSession = Depends(get_session),
    current_user = Depends(get_current_user)
):
    
    service = AssessmentService(session)
    saved_answer, answered_count, remaining_count, is_completed = await service.auto_save_answer(assmt_session_uid, current_user, payload)
    
    question_item = QuestionData(
        uid=saved_answer.question.uid,
        question_number=saved_answer.question.question_number,
        question_text=saved_answer.question.question_text,
        answer=AnswerData(answer_score=saved_answer.answer_score)
    )
    
    response_data = AutoSaveResponse(
        answered_count=answered_count,
        remaining_count=remaining_count,
        is_completed= is_completed,
        new_answer= question_item
    )

    return BaseResponse(
        message="Jawaban berhasil disimpan.",
        data=response_data
    )

@assmt_router.post(
    '/{session_uid}/submit', 
    response_model=BaseResponse[AssessmentResultResponse], 
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
)
async def submit_assessment_endpoint(
    assmt_session_uid: uuid.UUID,
    session: AsyncSession = Depends(get_session),
    current_user = Depends(get_current_user)
):

    
    service = AssessmentService(session)
    result = await service.submit_assessment(assmt_session_uid, current_user)

    user_data_items = UserData(
        user_uid=result.created_by.uid,
        name=result.created_by.name
    )

    response_data = AssessmentResultResponse(
        user=user_data_items,
        uid=result.uid,
        session_uid=result.session_uid,
        depression_score=result.depression_score,
        anxiety_score=result.anxiety_score,
        stress_score=result.stress_score,
        depression_level=result.depression_level,
        anxiety_level=result.anxiety_level,
        stress_level=result.stress_level,
        is_high_risk=result.is_high_risk,
        finished_at=result.session.finished_at
    )

    return BaseResponse(
        message="Tes berhasil tersubmit",
        data=response_data
    )