import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Employee } from './employee.entity.js';
import { EmployeeAssignment } from './entities/employee_assigments.entity.js';
import { Department } from './entities/departament.entity.js';

@Module({
    imports: [
        TypeOrmModule.forFeature([
            Employee,
            EmployeeAssignment,
            Department,
        ]),
    ],
})
export class EmployeesModule {}