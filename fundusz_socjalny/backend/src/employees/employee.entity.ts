import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('employees')
@Index('uq_employees_user_id', ['userId'], { unique: true })
@Index('idx_employees_last_first_name', ['lastName', 'firstName'])
export class Employee {
  @PrimaryGeneratedColumn({
    name: 'employee_id',
    type: 'bigint',
    unsigned: true,
  })
  employeeId: string;

  @Column({
    name: 'user_id',
    type: 'bigint',
    unsigned: true,
    nullable: true,
  })
  userId: string | null;

  @Column({
    name: 'first_name',
    type: 'varchar',
    length: 100,
  })
  firstName: string;

  @Column({
    name: 'last_name',
    type: 'varchar',
    length: 100,
  })
  lastName: string;

  @Column({
    name: 'is_active',
    type: 'boolean',
    default: true,
  })
  isActive: boolean;

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