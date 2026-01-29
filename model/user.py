from .base import Base
import enum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey, Enum
from typing import List, Optional

class UserRole(enum.Enum):
    ADMIN = "admin"
    USER = "user"

class User(Base):
    __tablename__ = "user"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(32))
    role: Mapped[UserRole] = mapped_column(
        Enum(UserRole, name="user_role_enum"),
        nullable=False,
        default=UserRole.USER,
    )
    encrypted_password: Mapped[str] #тре подивитись як то делать #also chatgipiti says hashed better
    age: Mapped[int]
    gender: Mapped[str | None] = mapped_column(String(30))
    location: Mapped[str | None] = mapped_column(String(100))

    ratings: Mapped[List["Rating"]] = relationship(back_populates="user")
    tolisten: Mapped["ToListen"] = relationship(back_populates="user")
