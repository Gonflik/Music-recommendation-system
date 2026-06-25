"""nullable song_position

Revision ID: a481d7f5b396
Revises: 29c645eec193
Create Date: 2026-06-25 10:16:08.832291

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'a481d7f5b396'
down_revision = '29c645eec193'
branch_labels = None
depends_on = None


def upgrade():
    op.execute("""
        CREATE TABLE IF NOT EXISTS recommendation (
            id SERIAL PRIMARY KEY,
            reference_name user_action_object_enum NOT NULL,
            reference_ids INTEGER[] NOT NULL,
            created_at TIMESTAMP NOT NULL,
            user_id INTEGER NOT NULL REFERENCES "user"(id)
        )
    """)

    with op.batch_alter_table('album_genre_association', schema=None) as batch_op:
        batch_op.drop_constraint(batch_op.f('album_genre_association_album_id_fkey'), type_='foreignkey')
        batch_op.create_foreign_key(None, 'album', ['album_id'], ['id'])

    with op.batch_alter_table('song', schema=None) as batch_op:
        batch_op.alter_column('song_position',
               existing_type=sa.INTEGER(),
               nullable=True)
        batch_op.drop_constraint(batch_op.f('song_album_id_fkey'), type_='foreignkey')
        batch_op.create_foreign_key(None, 'album', ['album_id'], ['id'])


def downgrade():
    with op.batch_alter_table('song', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.create_foreign_key(batch_op.f('song_album_id_fkey'), 'album', ['album_id'], ['id'], ondelete='CASCADE')
        batch_op.alter_column('song_position',
               existing_type=sa.INTEGER(),
               nullable=False)

    with op.batch_alter_table('album_genre_association', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.create_foreign_key(batch_op.f('album_genre_association_album_id_fkey'), 'album', ['album_id'], ['id'], ondelete='CASCADE')

    op.execute("DROP TABLE IF EXISTS recommendation")
