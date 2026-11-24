import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('users')
@Index('uq_users_username', ['username'], { unique: true })
@Index('uq_users_email', ['email'], { unique: true })
export class User {
  @PrimaryGeneratedColumn({
    name: 'user_id',
    type: 'bigint',
    unsigned: true,
  })
  userId: string;

  @Column({
    name: 'username',
    type: 'varchar',
    length: 100,
  })
  username: string;

  @Column({
    name: 'email',
    type: 'varchar',
    length: 255,
  })
  email: string;

  @Column({
    name: 'password_hash',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  passwordHash: string | null;

  @Column({
    name: 'is_active',
    type: 'boolean',
    default: true,
  })
  isActive: boolean;

  @Column({
    name: 'is_activated',
    type: 'boolean',
    default: false,
  })
  isActivated: boolean;

  @Column({
    name: 'activated_at',
    type: 'datetime',
    nullable: true,
  })
  activatedAt: Date | null;

  @CreateDateColumn({
    name: 'created_at',
    type: 'datetime',
  })
  createdAt: Date;

  @UpdateDateColumn({
    name: 'updated_at',
    type: 'datetime',
  })
  updatedAt: Date;
}