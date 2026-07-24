"""update_ck_length_value

Revision ID: 0011b0775f44
Revises: e70b0bd0853d
Create Date: 2026-07-12 08:32:07.016053

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '0011b0775f44'
down_revision = 'e70b0bd0853d'
branch_labels = None
depends_on = None

def upgrade():
    op.drop_constraint('ck_length_value', 'song', type_='check')
    op.create_check_constraint('ck_length_value', 'song', 'length > 5')

def downgrade():
    op.drop_constraint('ck_length_value', 'song', type_='check')
    op.create_check_constraint('ck_length_value', 'song', 'length > 30')
