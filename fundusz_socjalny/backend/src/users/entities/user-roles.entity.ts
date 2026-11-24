import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('user_roles')
export class UserRole {
  @PrimaryColumn({
    name: 'user_id',
    type: 'bigint',
    unsigned: true,
  })
  userId: string;

  @PrimaryColumn({
    name: 'role_id',
    type: 'bigint',
    unsigned: true,
  })
  roleId: string;

  @CreateDateColumn({
    name: 'assigned_at',
    type: 'datetime',
  })
  assignedAt: Date;

  @Column({
    name: 'assigned_by',
    type: 'bigint',
    unsigned: true,
    nullable: true,
  })
  assignedBy: string | null;
}