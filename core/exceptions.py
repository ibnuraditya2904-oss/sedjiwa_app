from datetime import timedelta
from fastapi import status

class AppException(Exception):
    """Base Exception murni Python (Steril dari urusan Web)"""
    def __init__(self, error: str, message: str, status_code: int = status.HTTP_400_BAD_REQUEST):
        self.error = error
        self.message = message
        self.status_code = status_code
        super().__init__(message)

# --- AUTH & USER EXCEPTIONS ---
class InvalidCredentialException(AppException):
    def __init__(self):
        super().__init__(
            error="Invalid Credential",
            message="Email atau Password Salah", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class InvalidTokenException(AppException):
    def __init__(self):
        super().__init__(
            error="Token is invalid or expired",
            message="Please provide a valid token or get a new one.", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class RevokedTokenException(AppException):
    def __init__(self):
        super().__init__(
            error="Token is invalid or has benn revoked",
            message="Please provide a valid token or get a new one.", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class AccessTokenException(AppException):
    def __init__(self):
        super().__init__(
            error="Invalid access token",
            message="Please provide a valid access token", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class RefreshTokenException(AppException):
    def __init__(self):
        super().__init__(
            error="Invalid refresh token",
            message="Please provide a valid refresh token", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class PasswordException(AppException):
    def __init__(self):
        super().__init__(
            error="Invalid password",
            message="Password Salah", 
            status_code=status.HTTP_401_UNAUTHORIZED
        )

class EmailAlreadyExistException(AppException):
    def __init__(self, email: str):
        super().__init__(
            error="Email Already Exist",
            message=f"Email {email} telah terdaftar.", 
            status_code=status.HTTP_400_BAD_REQUEST
        )

class UserNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="User Not Found",
            message="User tidak ditemukan di sistem.", 
            status_code=status.HTTP_404_NOT_FOUND
        )

class UserInactiveException(AppException):
    def __init__(self):
        super().__init__(
            error="User Inactive",
            message="User tidak aktif. Silahkan hubungi admin", 
            status_code=status.HTTP_403_FORBIDDEN
        )



# # --- QUESTION EXCEPTIONS ---

class PackageAlreadyExistException(AppException):
    def __init__(self, title: str):
        super().__init__(
            error="Package Already Exist",
            message=f"Paket dengan judul {title} telah terdaftar", 
            status_code=status.HTTP_400_BAD_REQUEST
        )
        
class PackageNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="Package Not Found",
            message="Paket Soal tidak ditemukan", 
            status_code=status.HTTP_404_NOT_FOUND
        )
    
class QuestionNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="Question Not Found",
            message="Pertanyaan tidak ditemukan", 
            status_code=status.HTTP_404_NOT_FOUND
        )

class PackageActiveException(AppException):
    def __init__(self):
        super().__init__(
            error="Package Active",
            message="Tidak dapat menghapus paket yang sedang aktif. Nonaktifkan terlebih dahulu", 
            status_code=status.HTTP_400_BAD_REQUEST
        )

# # --- ASSESSMENT EXCEPTIONS ---

class AssmtCooldownException(AppException):
    def __init__(self, sisa_waktu: timedelta):
        days_left = sisa_waktu.days
        hours_left = sisa_waktu.seconds // 3600
        
        detail_msg = f"Anda berada dalam masa cooldown. Silakan coba lagi dalam {days_left} hari {hours_left} jam."
        if days_left == 0:
            detail_msg = f"Anda berada dalam masa cooldown. Silakan coba lagi dalam {hours_left} jam."
            
        super().__init__(
            error="Cooldown Active",
            message=detail_msg,
            status_code=status.HTTP_403_FORBIDDEN
        )

class SessionNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="Session Not Found",
            message="Sesi tes tidak valid",
            status_code=status.HTTP_404_NOT_FOUND
        )

class SessionTimeException(AppException):
    def __init__(self):
        super().__init__(
            error="Session End Time",
            message="Sesi tes anda kadaluwarsa",
            status_code=status.HTTP_400_BAD_REQUEST
        )

class IncompleteAnswerException(AppException):
    def __init__(self, answered_count:int):
        super().__init__(
            error="Incomplete Answer",
            message=f"Belum semua soal dijawab. Baru terjawab {answered_count} dari 21 soal",
            status_code=status.HTTP_400_BAD_REQUEST
        )

class AnswerSaveException(AppException):
    def __init__(self):
        super().__init__(
            error="Answer Not Saved ",
            message="Jawaban anda tidak tersimpan",
            status_code=status.HTTP_400_BAD_REQUEST
        )

class ResultNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="Result Not Found",
            message="Hasil tes tidak ditemukan",
            status_code=status.HTTP_404_NOT_FOUND
        )

##-----Activity & RECOMMENDATION----

class ActivityNotFoundException(AppException):
    def __init__(self):
        super().__init__(
            error="Activity Not Found",
            message="Aktivitas tidak ditemukan.", 
            status_code=status.HTTP_404_NOT_FOUND
        )

class ActivityHasRelationException(AppException):
    def __init__(self):
        super().__init__(
            error="Activity Has Relation",
            message="Aktivitas tidak dapat dihapus karena sudah memiliki riwayat rekomendasi. Silakan ubah status menjadi non-aktif", 
            status_code=status.HTTP_400_BAD_REQUEST
        )


#------Recomendation
class AccessException(AppException):
    def __init__(self):
        super().__init__(
            error="Access Denied",
            message="Akses ditolak", 
            status_code=status.HTTP_403_FORBIDDEN
        )

class AssignedDateException(AppException):
    def __init__(self):
        super().__init__(
            error="Expired Date",
            message="Tugas hanya dapat diselesaikan pada hari yang telah dijadwalkan.", 
            status_code=status.HTTP_400_BAD_REQUEST
        )


# --- USER DASHBOARD ---

class HomeFetchFailedException(AppException):
    def __init__(self):
        super().__init__(
            error="Home Fetch Failed",
            message="Gagal memuat data halaman utama, silakan coba lagi nanti.",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

class RecommDashboardFetchFailedException(AppException):
    def __init__(self):
        super().__init__(
            error="Recommendation Dashboard Fetch Failed",
            message="Gagal memuat dashboard rekomendasi, silakan coba beberapa saat lagi.",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

#---- Admin--
class AdminSummaryFetchFailed(AppException):
    def __init__(self):
        super().__init__(
            error="Admin Summary Error",
            message="Gagal memuat ringkasan performa sistem untuk landing page admin.",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


#-----Psychologist
class PsychologistSummaryFetchFailed(AppException):
    def __init__(self):
        super().__init__(
            error="Psychologist Summary Error",
            message="Gagal memuat ringkasan data klinis untuk landing page psikolog.",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


class RecommDashboardFetchFailed(AppException):
    def __init__(self):
        super().__init__(
            error="Recommendation Dashboard Fetch Failed",
            message="Gagal memuat dashboard rekomendasi aktivitas.",
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

class DassDashboardFetchFailed(AppException):
    def __init__(self, message: str = "Gagal memuat dashboard kesehatan mental."):
        super().__init__(
            error="DASS Dashboard Error",
            message=message,
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR
        )