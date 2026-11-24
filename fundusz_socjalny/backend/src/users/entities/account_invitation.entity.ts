import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index
  //Check
} from 'typeorm';

@Entity('account_invitations')
@Index('uq_account_invitations_token_hash', ['tokenHash'], { unique: true })
@Index('idx_account_invitations_user_id', ['userId'])
@Index('idx_account_invitations_expires_at', ['expiresAt'])
@Index('idx_account_invitations_invited_by', ['invitedBy'])

export class AccountInvitation {
  @PrimaryGeneratedColumn({
    name: 'invitation_id',
    type: 'bigint',
    unsigned: true,

  })
  invitationId: string; 

    @Column({
    name: 'user_id',
    type: 'bigint',
    unsigned: true,
  })
  userId: string;

    @Column({
    name: 'token_hash',
    type: 'char',
    length: 64,
    charset: 'ascii',
    collation: 'ascii_bin',
  })
  tokenHash: string;

    @Column({
    name: 'expires_at',
    type: 'datetime',
  })
  expiresAt: Date;

    @Column({
    name: 'used_at',
    type: 'datetime',
    nullable: true,
  })
  usedAt: Date | null;

    @Column({
        name: 'revoked_at',
        type: 'datetime',
        nullable: true,
    })
    revokedAt: Date | null;

    @CreateDateColumn({
        name: 'created_at',
        type: 'datetime',
    })
    createdAt: Date;

    @Column({
        name: 'invited_by',
        type: 'bigint',
        unsigned: true,
        nullable: true,
    })
    invitedBy: string| null;
}