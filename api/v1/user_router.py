from fastapi import APIRouter, Depends,status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.api.debs import get_session, get_current_user
from app.models.user import User
from app.schemas.user_schemas import UserResponseModel, UserProfileUpdateModel, UserChangePassModel
from app.services.user_services import UserService
from app.schemas.base import BaseResponse


user_router = APIRouter()

@user_router.get(
    "", 
    response_model=BaseResponse[UserResponseModel], 
    status_code=status.HTTP_200_OK)
async def get_current_user_endpoint(
    current_user: User = Depends(get_current_user)
):
    response_data = UserResponseModel(
        uid= current_user.uid,
        name=current_user.name,
        email=current_user.email,
        role=current_user.role,
        gender=current_user.gender,
        date_of_birth=current_user.date_of_birth
    )
    
    return BaseResponse(
        message="Data user berhasil diambil",
        data=response_data
    )

@user_router.patch(
    "", 
    response_model=BaseResponse[UserResponseModel], 
    status_code=status.HTTP_200_OK)
async def user_update_profile_endpoint(
    update_profile_data: UserProfileUpdateModel,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)
) -> dict:
    user_service = UserService(session)
    result = await user_service.update_profile(update_profile_data,current_user)
    
    response_data = UserResponseModel(
        uid= result.uid,
        name=result.name,
        email=result.email,
        role=result.role,
        gender=result.gender,
        date_of_birth=result.date_of_birth
    )
    
    return BaseResponse(
        message="Profile berhasil diperbarui",
        data=response_data
    )

@user_router.patch(
    "/password",
    response_model=BaseResponse,
    status_code=status.HTTP_200_OK)
async def user_change_pass_endpoint(
    user_change_pass_data: UserChangePassModel,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    user_service = UserService(session)
    await user_service.user_change_pass(user_change_pass_data, current_user)
    
    return BaseResponse(
        message="Password berhasil diperbarui",
        data=None
    )