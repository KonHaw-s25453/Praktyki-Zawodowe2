import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('departments')
@Index('idx_departments_parent_id', ['parentDepartmentId'])
@Index('idx_departments_name', ['departmentName'])

export class Department {

@PrimaryGeneratedColumn({
  name: 'department_id',
  type: 'bigint',
  unsigned: true,
})
departmentId: string;

@Column({
  name: 'department_name',
  type: 'varchar',
  length: 150,
})
departmentName: string;
@Column({
  name: 'parent_department_id',
  type: 'bigint',
  unsigned: true,
  nullable: true,
})
parentDepartmentId: string | null;

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