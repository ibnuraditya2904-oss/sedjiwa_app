import uuid
from fastapi import APIRouter, Depends, status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.models.enum import UserRole
from app.schemas.base import BaseResponse 
from app.schemas.recomm_schemas import DailyActivityItem, DailySlotResponse, PoolActivityItem, RecommendationPoolResponse
from app.api.debs import  get_current_user, get_session, require_roles
from app.services.recomm_services import RecommendationService

recomm_router = APIRouter()

@recomm_router.post(
    '/generate/{assmt_result_uid}', 
    response_model=BaseResponse[RecommendationPoolResponse], 
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(require_roles([UserRole.user]))]
    )
async def generate_pool_cosine(
    assmt_result_uid: uuid.UUID,
    session: AsyncSession = Depends(get_session),
    current_user = Depends(get_current_user)
):
    recomm_service = RecommendationService(session)
    result = await recomm_service.generate_pool(assmt_result_uid, current_user)
    
    pool_items = []
    for pa in result.pool_activities:
        pool_items.append(
            PoolActivityItem(
                activity_uid=pa.activity_uid,
                activity_title=pa.activity.title,
                similarity_score=pa.similarity_score,
                rank=pa.rank
            )
        )

    response_data = RecommendationPoolResponse(
        pool_uid=result.uid,
        user_uid=result.user_uid,
        user_name=result.created_by.name,
        assmt_result_uid=result.assmt_result_uid,
        activities=pool_items
    )
    return BaseResponse(
        message="Pool Rekomendasi berhasil dibuat menggunakan Cosine Similarity",
        data=response_data
    )

@recomm_router.get(
    '/daily_activities', 
    response_model=BaseResponse[DailySlotResponse], 
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
    )
async def get_daily_tasks(
    session: AsyncSession = Depends(get_session),
    current_user = Depends(get_current_user)
):
    recomm_service = RecommendationService(session)
    
    today_activities = await recomm_service.generate_or_get_daily_slots(current_user)
    
    if not today_activities:
        return BaseResponse(message="Belum ada aktivitas.", data=None)

    activity_items = [
        DailyActivityItem(
            uid=today_activity.uid,
            slot_number=today_activity.slot_number,
            activity_uid=today_activity.activity_uid,
            activity_title=today_activity.activity.title, 
            is_completed=today_activity.is_completed
        ) for today_activity in today_activities
    ]

    response_data = DailySlotResponse(
        user_uid=today_activities[0].user_uid,
        user_name=today_activities[0].created_by.name,
        assigned_date=today_activities[0].assigned_date,
        activities=activity_items
    )

    return BaseResponse(
        message="Daftar aktivitas harian berhasil dimuat",
        data=response_data
    )

@recomm_router.patch(
    '/{checklist_uid}/complete',
    response_model=BaseResponse[DailyActivityItem], 
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(require_roles([UserRole.user]))]
    )
async def complete_task(
    checklist_uid: uuid.UUID,
    session: AsyncSession = Depends(get_session),
    current_user = Depends(get_current_user)
):
    recomm_service = RecommendationService(session)
    
    result = await recomm_service.complete_daily_task(checklist_uid, current_user)

    response_data = DailyActivityItem(
        uid=result.uid,
        slot_number=result.slot_number,
        activity_uid=result.activity_uid,
        activity_title=result.activity.title, 
        is_completed=result.is_completed
    )
    
    return BaseResponse(
        message="Aktivitas berhasil ditandai selesai",
        data=response_data
    )