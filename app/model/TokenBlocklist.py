from app.extensions import db
from .base import Base
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import DateTime, func, select
from datetime import datetime, timezone

class TokenBlocklist(Base):
    __tablename__ = 'tokenblocklist'

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    jti: Mapped[str] = mapped_column(index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    @classmethod
    def select_token_by_jti(cls, jti):
        stmt = select(cls).where(cls.jti == jti)
        token = db.session.scalar(stmt)
        return token

    def save(self):
        db.session.add(self)
        db.session.commit()

    def __repr__(self):
        return f"<Token {self.jti}>" 
    