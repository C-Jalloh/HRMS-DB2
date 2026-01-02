// Mock Data for HRMS Dashboard
// In a real application, this would be fetched from the backend API

const dashboardData = {
    kpi: {
        totalEmployees: 142,
        activeEmployees: 138,
        pendingLeaves: 12,
        payrollCost: "$845,200"
    },
    
    departmentDistribution: {
        labels: ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations'],
        data: [45, 30, 20, 12, 15, 20],
        colors: ['#4361ee', '#3f37c9', '#4895ef', '#4cc9f0', '#f72585', '#7209b7']
    },
    
    attendanceTrend: {
        labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        data: [96, 95, 97, 94, 96, 98]
    },
    
    leaveStatus: {
        labels: ['Approved', 'Pending', 'Rejected'],
        data: [65, 12, 5],
        colors: ['#22c55e', '#f97316', '#ef4444']
    },
    
    recentActivities: [
        { type: 'hire', title: 'New Hire', desc: 'Sarah Johnson joined Engineering', time: '2 hours ago', icon: 'fa-user-plus' },
        { type: 'leave', title: 'Leave Request', desc: 'Mike Smith requested annual leave', time: '4 hours ago', icon: 'fa-calendar-plus' },
        { type: 'payroll', title: 'Payroll Processed', desc: 'November payroll completed', time: '1 day ago', icon: 'fa-money-check' },
        { type: 'attendance', title: 'Late Arrival', desc: 'John Doe clocked in late', time: '1 day ago', icon: 'fa-clock' },
        { type: 'promotion', title: 'Promotion', desc: 'Emily Davis promoted to Senior Dev', time: '2 days ago', icon: 'fa-arrow-trend-up' }
    ],
    
    employeesByPosition: {
        labels: ['Junior', 'Mid-Level', 'Senior', 'Lead', 'Manager', 'Director'],
        data: [40, 55, 30, 10, 5, 2]
    },
    
    hiringTrend: {
        labels: ['2019', '2020', '2021', '2022', '2023', '2024'],
        data: [15, 22, 35, 28, 42, 38]
    },
    
    newHires: [
        { name: 'Alex Thompson', dept: 'Engineering', position: 'Frontend Dev', date: '2024-12-01' },
        { name: 'Maria Garcia', dept: 'Marketing', position: 'Content Specialist', date: '2024-11-28' },
        { name: 'James Wilson', dept: 'Sales', position: 'Sales Rep', date: '2024-11-25' },
        { name: 'Linda Chen', dept: 'Finance', position: 'Accountant', date: '2024-11-20' },
        { name: 'Robert Taylor', dept: 'Operations', position: 'Ops Manager', date: '2024-11-15' }
    ],
    
    leaveBalance: {
        labels: ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance'],
        annual: [450, 300, 200, 120, 150],
        sick: [220, 150, 100, 60, 75]
    },
    
    monthlyLeaveUsage: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        data: [15, 12, 18, 22, 25, 30, 45, 50, 20, 15, 18, 40]
    },
    
    avgHours: {
        labels: ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance'],
        data: [8.5, 8.2, 8.0, 7.8, 8.1]
    },
    
    weeklyAttendance: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
        present: [138, 135, 137, 136, 130],
        late: [2, 5, 3, 4, 8]
    },
    
    salaryRange: {
        labels: ['<30k', '30k-50k', '50k-70k', '70k-90k', '>90k'],
        data: [10, 45, 50, 25, 12]
    },
    
    deptSalary: {
        labels: ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance'],
        data: [85000, 72000, 68000, 65000, 75000]
    }
};
