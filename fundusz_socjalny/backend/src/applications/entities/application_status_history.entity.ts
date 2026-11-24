import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  Check,
} from 'typeorm';

import { Application } from './application.entity.js';
import { User } from '../../users/entities/user.entity.js';

@Entity('application_status_history')
@Index('idx_application_history_application', ['applicationId', 'changedAt'])
@Index('idx_application_history_user', ['changedBy'])
@Check(
  'chk_application_history_new_status',
  "`new_status` IN ('DRAFT','SUBMITTED','UNDER_REVIEW','REQUIRES_CORRECTION','APPROVED','REJECTED','WITHDRAWN')"
)
@Check(
  'chk_application_history_previous_status',
  "`previous_status` IS NULL OR `previous_status` IN ('DRAFT','SUBMITTED','UNDER_REVIEW','REQUIRES_CORRECTION','APPROVED','REJECTED','WITHDRAWN')"
)

export class ApplicationStatusHistory {
    @PrimaryGeneratedColumn({
  name: 'history_id',
  type: 'bigint',
  unsigned: true,
})
historyId: string;

@Column({ name: 'application_id', type: 'bigint', unsigned: true })
applicationId: string;

@ManyToOne(() => Application, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'application_id',
  referencedColumnName: 'applicationId',
})
application: Application;

@Column({ name: 'changed_by', type: 'bigint', unsigned: true, nullable: true })
changedBy: string | null;
@ManyToOne(() => User, {
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
  nullable: true,
})
@JoinColumn({ name: 'changed_by', referencedColumnName: 'userId' })
changedByUser: User | null;

@Column({ name: 'previous_status', type: 'varchar', length: 30, nullable: true })
previousStatus: string | null;

@Column({ name: 'new_status', type: 'varchar', length: 30 })
newStatus: string;

@CreateDateColumn({ name: 'changed_at', type: 'datetime' })
changedAt: Date;

@Column({ name: 'comment', type: 'text', nullable: true })
comment: string | null;

}