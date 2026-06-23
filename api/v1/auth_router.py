from fastapi import APIRouter, Depends,status
from sqlmodel.ext.asyncio.session import AsyncSession
from app.schemas.base import BaseResponse
from app.api.debs import AccessTokenBearer, get_session, RefreshTokenBearer
from app.core.redis import add_jti_to_blacklist
from app.core.security import generate_auth_token
from app.schemas.user_schemas import UserCreateModel, UserMinResponseData, UserResponseModel, UserLoginModel, LoginResponseData, TokenResponseData
from app.services.user_services import UserService

auth_routers = APIRouter()

@auth_routers.post(
    "/signup", 
    response_model=BaseResponse[UserResponseModel],
    status_code=status.HTTP_201_CREATED)
async def create_user_endpoint(
    user_data : UserCreateModel,
    session: AsyncSession = Depends(get_session)
):
    user_service = UserService(session)
    result =await user_service.register_user(user_data)

    response_data = UserResponseModel(
        uid= result.uid,
        name= result.name,
        email= result.email,
        role= result.role,
        gender= result.gender,
        date_of_birth= result.date_of_birth
    )

    return BaseResponse(
        message="Akun berhasil dibuat",
        data=response_data
    )

@auth_routers.post(
    "/login",
    response_model=BaseResponse[LoginResponseData],
    status_code=status.HTTP_200_OK)
async def login_user_endpoint(
    login_data : UserLoginModel,
    session: AsyncSession = Depends(get_session)
):
    user_service = UserService(session)
    tokens, user= await user_service.login_user(login_data)


    items = UserMinResponseData(
        uid= user.uid,
        name= user.name,
        email= user.email,
        role= user.role
    )

    response_data = LoginResponseData(
        access_token= tokens["access_token"],
        refresh_token= tokens["refresh_token"],
        token_type= tokens["token_type"],
        user= items
    )

    return BaseResponse(
        message="Login berhasil",
        data=response_data
    )

@auth_routers.post(
    "/refresh_token",
    response_model=BaseResponse[TokenResponseData],
    status_code=status.HTTP_200_OK
    )
async def get_new_access_token_endpoint(
    token_detail : dict = Depends(RefreshTokenBearer())
) :
    new_token = generate_auth_token(
        user_uid = token_detail['sub']
    )

    response_data = TokenResponseData(
        access_token=new_token["access_token"],
        refresh_token=new_token["refresh_token"],
        token_type=new_token["token_type"] 
    )

    return BaseResponse(
        message="Token berhasil diperbaarui",
        data=response_data
    )

@auth_routers.post(
    "/logout",
    response_model=BaseResponse,
    status_code=status.HTTP_200_OK
    )
async def logout(token_data:dict =Depends(AccessTokenBearer())):
    jti = token_data["jti"]
    exp = token_data["exp"]

    await add_jti_to_blacklist(jti, exp)

    return BaseResponse(
        message="Logout berhasil",
        data=None
    )
