import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('employee_assignments')
@Index('idx_employee_assignments_employee', ['employeeId'])
@Index('idx_employee_assignments_department', ['departmentId'])
@Index('idx_employee_assignments_dates', ['startDate', 'endDate'])

export class EmployeeAssignment {
  @PrimaryGeneratedColumn({
    name: 'assignment_id',
    type: 'bigint',
    unsigned: true,
  })
  assignmentId: string;

    @Column({
    name: 'employee_id',
    type: 'bigint',
    unsigned: true,
  })
  employeeId: string;

    @Column({
    name: 'department_id',
    type: 'bigint',
    unsigned: true,
  })
  departmentId: string;

    @Column({
        name: 'position_name',
        type: 'varchar',
        length: 150,
        nullable: true
    })
    positionName: string| null; 

    @Column({
        name: 'start_date',
        type: 'date',
    })
    startDate: Date;

    @Column({
        name: 'end_date',
        type: 'date',
        nullable: true,
    })
    endDate: Date | null;

    @CreateDateColumn({
        name: 'created_at',
        type: 'datetime',
    })
    createdAt: Date;
}