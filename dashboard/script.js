// HRMS Dashboard Script
const API_URL = 'http://localhost:3000/api';
let currentAdminId = null;
let currentPage = 1;
const limit = 10;

document.addEventListener('DOMContentLoaded', function() {
    // Set Current Date
    const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', dateOptions);

    // Initialize Dashboard
    loadCompanies();

    // Event Listener for Company Selector
    document.getElementById('companySelector').addEventListener('change', function(e) {
        currentAdminId = e.target.value;
        initDashboardData();
    });

    // Event Listener for Refresh Button
    document.getElementById('refreshBtn').addEventListener('click', refreshDashboard);
});

async function loadCompanies() {
    try {
        const response = await fetch(`${API_URL}/companies`);
        const companies = await response.json();
        const selector = document.getElementById('companySelector');
        
        companies.forEach(company => {
            const option = document.createElement('option');
            option.value = company.admin_id;
            option.textContent = company.company_name;
            selector.appendChild(option);
        });

        // Select the first company by default if available
        if (companies.length > 0) {
            currentAdminId = companies[0].admin_id;
            selector.value = currentAdminId;
            initDashboardData();
        }
    } catch (error) {
        console.error('Error loading companies:', error);
    }
}

function initDashboardData() {
    if (!currentAdminId) return;

    loadKPIs();
    loadRecentActivities();
    loadNewHires();
    loadDeptSummary();
    initCharts();
    loadEmployees(1); // Load first page of employees
}

async function loadKPIs() {
    try {
        const response = await fetch(`${API_URL}/kpi?admin_id=${currentAdminId}`);
        const data = await response.json();
        
        document.getElementById('kpi-total-employees').textContent = data.total || 0;
        document.getElementById('kpi-active-employees').textContent = data.active || 0;
        document.getElementById('kpi-pending-leaves').textContent = data.pending_leaves || 0;
        document.getElementById('kpi-payroll-cost').textContent = data.payroll ? '$' + data.payroll.toLocaleString() : '$0';
    } catch (error) {
        console.error('Error loading KPIs:', error);
        // Set default values on error
        document.getElementById('kpi-total-employees').textContent = '0';
        document.getElementById('kpi-active-employees').textContent = '0';
        document.getElementById('kpi-pending-leaves').textContent = '0';
        document.getElementById('kpi-payroll-cost').textContent = '$0';
    }
}

async function loadRecentActivities() {
    try {
        const response = await fetch(`${API_URL}/recent-activities?admin_id=${currentAdminId}`);
        const activities = await response.json();
        
        const container = document.getElementById('recent-activities');
        container.innerHTML = '';

        activities.forEach(activity => {
            const item = document.createElement('div');
            item.className = 'activity-item';
            
            let icon = 'fa-circle-info';
            if (activity.action_type === 'HIRE') icon = 'fa-user-plus';
            else if (activity.action_type === 'LEAVE') icon = 'fa-calendar-minus';
            else if (activity.action_type === 'PROMOTION') icon = 'fa-arrow-trend-up';

            item.innerHTML = `
                <div class="activity-icon">
                    <i class="fa-solid ${icon}"></i>
                </div>
                <div class="activity-details">
                    <h4>${activity.action_type}</h4>
                    <p>${activity.description}</p>
                </div>
                <div class="activity-time">${new Date(activity.action_date).toLocaleDateString()}</div>
            `;
            container.appendChild(item);
        });
    } catch (error) {
        console.error('Error loading activities:', error);
    }
}

async function loadNewHires() {
    try {
        const response = await fetch(`${API_URL}/new-hires?admin_id=${currentAdminId}`);
        const hires = await response.json();

        const tbody = document.getElementById('new-hires-table');
        tbody.innerHTML = '';

        hires.forEach(hire => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${hire.name}</td>
                <td>${hire.department_name}</td>
                <td>${hire.position}</td>
                <td>${new Date(hire.hire_date).toLocaleDateString()}</td>
            `;
            tbody.appendChild(row);
        });
    } catch (error) {
        console.error('Error loading new hires:', error);
    }
}

async function loadDeptSummary() {
    try {
        const response = await fetch(`${API_URL}/dept-summary?admin_id=${currentAdminId}`);
        const sectors = await response.json();

        const tbody = document.getElementById('dept-summary-table');
        tbody.innerHTML = '';

        sectors.forEach(row_data => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td style="font-weight: bold;">${row_data.department_name}</td>
                <td>${row_data.total_staff}</td>
                <td>$${(row_data.avg_salary || 0).toLocaleString()}</td>
                <td>
                    <div class="attendance-progress">
                        <span class="value">${row_data.avg_attendance || 0}%</span>
                        <div class="progress-bar"><div class="fill" style="width: ${row_data.avg_attendance || 0}%"></div></div>
                    </div>
                </td>
            `;
            tbody.appendChild(row);
        });
    } catch (error) {
        console.error('Error loading department summary:', error);
    }
}

// Paginated Employees
async function loadEmployees(page) {
    currentPage = page;
    try {
        const response = await fetch(`${API_URL}/employees?admin_id=${currentAdminId}&page=${page}&limit=${limit}`);
        const result = await response.json();
        const employees = result.data;
        const pagination = result.pagination;

        const tbody = document.getElementById('employees-table-body');
        tbody.innerHTML = '';

        employees.forEach(emp => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${emp.employee_id}</td>
                <td>${emp.name}</td>
                <td>${emp.email}</td>
                <td>${emp.department_name || 'N/A'}</td>
                <td>${emp.position}</td>
                <td>${new Date(emp.hire_date).toLocaleDateString()}</td>
            `;
            tbody.appendChild(row);
        });

        // Update Pagination Controls
        document.getElementById('pageInfo').textContent = `Page ${pagination.page} of ${pagination.totalPages}`;
        document.getElementById('prevPage').disabled = pagination.page === 1;
        document.getElementById('nextPage').disabled = pagination.page === pagination.totalPages;

    } catch (error) {
        console.error('Error loading employees:', error);
    }
}

function changePage(delta) {
    loadEmployees(currentPage + delta);
}

// Chart Configuration
const commonOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            position: 'bottom'
        }
    }
};

// Function to show no data message on canvas
function showNoDataMessage(canvasId, message = 'No data available') {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.font = '16px Arial';
    ctx.fillStyle = '#64748b';
    ctx.textAlign = 'center';
    ctx.fillText(message, canvas.width / 2, canvas.height / 2);
}

let charts = {}; // Store chart instances to destroy them before re-rendering

async function initCharts() {
    // Destroy existing charts if any
    if (charts.deptDistribution) charts.deptDistribution.destroy();
    if (charts.attendanceTrend) charts.attendanceTrend.destroy();
    if (charts.leaveStatus) charts.leaveStatus.destroy();
    if (charts.positionChart) charts.positionChart.destroy();
    if (charts.salaryRangeChart) charts.salaryRangeChart.destroy();
    if (charts.leaveBalanceChart) charts.leaveBalanceChart.destroy();
    if (charts.monthlyLeaveChart) charts.monthlyLeaveChart.destroy();
    if (charts.avgHoursChart) charts.avgHoursChart.destroy();
    if (charts.weeklyAttendanceChart) charts.weeklyAttendanceChart.destroy();
    if (charts.deptSalaryChart) charts.deptSalaryChart.destroy();

    // 1. Department Distribution Chart (Pie)
    try {
        const response = await fetch(`${API_URL}/dept-distribution?admin_id=${currentAdminId}`);
        const data = await response.json();
        
        const ctx = document.getElementById('deptDistributionChart');
        if (ctx) {
            if (data.length === 0) {
                showNoDataMessage('deptDistributionChart');
            } else {
                charts.deptDistribution = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: data.map(d => d.department_name),
                        datasets: [{
                            data: data.map(d => d.count),
                            backgroundColor: ['#4361ee', '#3a0ca3', '#7209b7', '#f72585', '#4cc9f0', '#22c55e', '#f97316'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        ...commonOptions,
                        plugins: {
                            ...commonOptions.plugins,
                            legend: {
                                display: data.length > 0
                            }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading dept distribution:', error);
        showNoDataMessage('deptDistributionChart', 'Error loading data');
    }

    // 2. Attendance Trend Chart (Line)
    try {
        const response = await fetch(`${API_URL}/attendance-trend?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('attendanceTrendChart');
        if (ctx) {
            if (data.length === 0) {
                showNoDataMessage('attendanceTrendChart');
            } else {
                charts.attendanceTrend = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.map(d => d.month),
                        datasets: [{
                            label: 'Attendance Rate (%)',
                            data: data.map(d => d.rate),
                            borderColor: '#4361ee',
                            backgroundColor: 'rgba(67, 97, 238, 0.1)',
                            tension: 0.4,
                            fill: true
                        }]
                    },
                    options: {
                        ...commonOptions,
                        scales: {
                            y: {
                                beginAtZero: false,
                                min: 0,
                                max: 100
                            }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading attendance trend:', error);
        showNoDataMessage('attendanceTrendChart', 'Error loading data');
    }

    // 3. Leave Status Chart (Pie)
    try {
        const response = await fetch(`${API_URL}/leave-status?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('leaveStatusChart');
        if (ctx) {
            if (data.length === 0 || data.every(d => d.count === 0)) {
                showNoDataMessage('leaveStatusChart');
            } else {
                charts.leaveStatus = new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: data.map(d => d.status.charAt(0).toUpperCase() + d.status.slice(1)),
                        datasets: [{
                            data: data.map(d => d.count),
                            backgroundColor: ['#f72585', '#4cc9f0', '#4361ee'],
                            borderWidth: 0
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading leave status:', error);
        showNoDataMessage('leaveStatusChart', 'Error loading data');
    }

    // 4. Position Distribution Chart (Bar)
    try {
        const response = await fetch(`${API_URL}/position-distribution?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('positionChart');
        if (ctx) {
            if (charts.positionChart) charts.positionChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No position data available');
            } else {
                charts.positionChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.position),
                        datasets: [{
                            label: 'Employees',
                            data: data.map(d => d.count),
                            backgroundColor: '#4361ee',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading position distribution:', error);
        const ctx = document.getElementById('positionChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading position data');
        }
    }

    // 4.1. Average Hours by Department Chart (Overview)
    try {
        const response = await fetch(`${API_URL}/avg-hours-dept?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('overviewAvgHoursChart');
        if (ctx) {
            if (charts.overviewAvgHoursChart) charts.overviewAvgHoursChart.destroy();

            if (data.length === 0) {
                showNoDataMessage(ctx, 'No attendance data available');
            } else {
                charts.overviewAvgHoursChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.department_name),
                        datasets: [{
                            label: 'Avg Hours',
                            data: data.map(d => d.avg_hours),
                            backgroundColor: '#7209b7',
                            borderRadius: 5
                        }]
                    },
                    options: {
                        ...commonOptions,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 10
                            }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading overview avg hours:', error);
        const ctx = document.getElementById('overviewAvgHoursChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading attendance data');
        }
    }

    // 4.2. Department Salary Comparison Chart (Overview)
    try {
        const response = await fetch(`${API_URL}/dept-salary-comparison?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('overviewDeptSalaryChart');
        if (ctx) {
            if (charts.overviewDeptSalaryChart) charts.overviewDeptSalaryChart.destroy();

            if (data.length === 0) {
                showNoDataMessage(ctx, 'No salary data available');
            } else {
                charts.overviewDeptSalaryChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.department_name),
                        datasets: [{
                            label: 'Avg Salary ($)',
                            data: data.map(d => d.avg_salary),
                            backgroundColor: '#4895ef',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading overview dept salary:', error);
        const ctx = document.getElementById('overviewDeptSalaryChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading salary data');
        }
    }

    // 5. Salary Range Chart (Bar)
    try {
        const response = await fetch(`${API_URL}/salary-distribution?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('salaryRangeChart');
        if (ctx) {
            if (charts.salaryRangeChart) charts.salaryRangeChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No salary data available');
            } else {
                charts.salaryRangeChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.salary_range),
                        datasets: [{
                            label: 'Employees',
                            data: data.map(d => d.count),
                            backgroundColor: '#3f37c9',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading salary distribution:', error);
        const ctx = document.getElementById('salaryRangeChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading salary data');
        }
    }

    // 6. Leave Balance Chart (Stacked Bar)
    try {
        const response = await fetch(`${API_URL}/leave-balance?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('leaveBalanceChart');
        if (ctx) {
            if (charts.leaveBalanceChart) charts.leaveBalanceChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No leave data available');
            } else {
                charts.leaveBalanceChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.leave_name),
                        datasets: [
                            {
                                label: 'Balance',
                                data: data.map(d => d.total_balance),
                                backgroundColor: '#4361ee'
                            },
                            {
                                label: 'Used',
                                data: data.map(d => d.total_used),
                                backgroundColor: '#f72585'
                            }
                        ]
                    },
                    options: {
                        ...commonOptions,
                        scales: {
                            x: { stacked: true },
                            y: { stacked: true }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading leave balance:', error);
        const ctx = document.getElementById('leaveBalanceChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading leave data');
        }
    }

    // 7. Monthly Leave Usage (Bar)
    try {
        const response = await fetch(`${API_URL}/monthly-leave-usage?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('monthlyLeaveChart');
        if (ctx) {
            if (charts.monthlyLeaveChart) charts.monthlyLeaveChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No leave usage data available');
            } else {
                charts.monthlyLeaveChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.month),
                        datasets: [{
                            label: 'Days Used',
                            data: data.map(d => d.days_used),
                            backgroundColor: '#f72585',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading monthly leave usage:', error);
        const ctx = document.getElementById('monthlyLeaveChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading leave usage data');
        }
    }

    // 8. Average Hours Chart (Bar)
    try {
        const response = await fetch(`${API_URL}/avg-hours-dept?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('avgHoursChart');
        if (ctx) {
            if (charts.avgHoursChart) charts.avgHoursChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No attendance data available');
            } else {
                charts.avgHoursChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.department_name),
                        datasets: [{
                            label: 'Avg Hours',
                            data: data.map(d => d.avg_hours),
                            backgroundColor: '#7209b7',
                            borderRadius: 5
                        }]
                    },
                    options: {
                        ...commonOptions,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 10
                            }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading avg hours:', error);
        const ctx = document.getElementById('avgHoursChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading attendance data');
        }
    }

    // 9. Weekly Attendance Chart (Grouped Bar)
    try {
        const response = await fetch(`${API_URL}/weekly-attendance?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('weeklyAttendanceChart');
        if (ctx) {
            if (charts.weeklyAttendanceChart) charts.weeklyAttendanceChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No attendance data available');
            } else {
                charts.weeklyAttendanceChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.day),
                        datasets: [
                            {
                                label: 'Present',
                                data: data.map(d => d.present),
                                backgroundColor: '#22c55e'
                            },
                            {
                                label: 'Late',
                                data: data.map(d => d.late),
                                backgroundColor: '#f97316'
                            }
                        ]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading weekly attendance:', error);
        const ctx = document.getElementById('weeklyAttendanceChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading attendance data');
        }
    }

    // 10. Department Salary Chart (Bar)
    try {
        const response = await fetch(`${API_URL}/dept-salary-comparison?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('deptSalaryChart');
        if (ctx) {
            if (charts.deptSalaryChart) charts.deptSalaryChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No salary data available');
            } else {
                charts.deptSalaryChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.department_name),
                        datasets: [{
                            label: 'Avg Salary ($)',
                            data: data.map(d => d.avg_salary),
                            backgroundColor: '#4895ef',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading dept salary comparison:', error);
        const ctx = document.getElementById('deptSalaryChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading salary data');
        }
    }
}

// Refresh Dashboard Data
function refreshDashboard() {
    if (!currentAdminId) return;
    
    // Show loading state
    const refreshBtn = document.getElementById('refreshBtn');
    const originalText = refreshBtn.innerHTML;
    refreshBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Refreshing...';
    refreshBtn.disabled = true;
    
    // Reload all data
    loadKPIs();
    loadRecentActivities();
    loadNewHires();
    initCharts();
    loadEmployees(currentPage);
    
    // Refresh section-specific charts if active
    const activeSection = document.querySelector('.dashboard-section.active');
    if (activeSection) {
        if (activeSection.id === 'employees-section') {
            loadEmployeeCharts();
        } else if (activeSection.id === 'leave-section') {
            loadLeaveCharts();
        }
    }
    
    // Reset button after 2 seconds
    setTimeout(() => {
        refreshBtn.innerHTML = originalText;
        refreshBtn.disabled = false;
    }, 2000);
}

// Load Employee Section Charts
async function loadEmployeeCharts() {
    if (!currentAdminId) return;

    // Position Distribution Chart for Employees
    try {
        const response = await fetch(`${API_URL}/position-distribution?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('employeesPositionChart');
        if (ctx) {
            if (charts.employeesPositionChart) charts.employeesPositionChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No position data available');
            } else {
                charts.employeesPositionChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.position),
                        datasets: [{
                            label: 'Employees',
                            data: data.map(d => d.count),
                            backgroundColor: '#4361ee',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading employee position distribution:', error);
        const ctx = document.getElementById('employeesPositionChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading position data');
        }
    }

    // Salary Distribution Chart for Employees
    try {
        const response = await fetch(`${API_URL}/salary-distribution?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('employeesSalaryChart');
        if (ctx) {
            if (charts.employeesSalaryChart) charts.employeesSalaryChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No salary data available');
            } else {
                charts.employeesSalaryChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.salary_range),
                        datasets: [{
                            label: 'Employees',
                            data: data.map(d => d.count),
                            backgroundColor: '#3f37c9',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading employee salary distribution:', error);
        const ctx = document.getElementById('employeesSalaryChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading salary data');
        }
    }
}

// Load Leave Section Charts
async function loadLeaveCharts() {
    if (!currentAdminId) return;

    // Leave Balance Chart
    try {
        const response = await fetch(`${API_URL}/leave-balance?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('leaveBalanceChart');
        if (ctx) {
            if (charts.leaveBalanceChart) charts.leaveBalanceChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No leave data available');
            } else {
                charts.leaveBalanceChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.leave_name),
                        datasets: [
                            {
                                label: 'Balance',
                                data: data.map(d => d.total_balance),
                                backgroundColor: '#4361ee'
                            },
                            {
                                label: 'Used',
                                data: data.map(d => d.total_used),
                                backgroundColor: '#f72585'
                            }
                        ]
                    },
                    options: {
                        ...commonOptions,
                        scales: {
                            x: { stacked: true },
                            y: { stacked: true }
                        }
                    }
                });
            }
        }
    } catch (error) {
        console.error('Error loading leave balance:', error);
        const ctx = document.getElementById('leaveBalanceChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading leave data');
        }
    }

    // Monthly Leave Usage Chart
    try {
        const response = await fetch(`${API_URL}/monthly-leave-usage?admin_id=${currentAdminId}`);
        const data = await response.json();

        const ctx = document.getElementById('monthlyLeaveChart');
        if (ctx) {
            if (charts.monthlyLeaveChart) charts.monthlyLeaveChart.destroy();
            
            if (data.length === 0) {
                showNoDataMessage(ctx, 'No leave usage data available');
            } else {
                charts.monthlyLeaveChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.map(d => d.month),
                        datasets: [{
                            label: 'Days Used',
                            data: data.map(d => d.days_used),
                            backgroundColor: '#f72585',
                            borderRadius: 5
                        }]
                    },
                    options: commonOptions
                });
            }
        }
    } catch (error) {
        console.error('Error loading monthly leave usage:', error);
        const ctx = document.getElementById('monthlyLeaveChart');
        if (ctx) {
            showNoDataMessage(ctx, 'Error loading leave usage data');
        }
    }
}

// Tab Switching Logic
function switchTab(tabId) {
    // Update Sidebar Active State
    document.querySelectorAll('.sidebar li').forEach(li => {
        li.classList.remove('active');
    });
    event.currentTarget.classList.add('active');

    // Show/Hide Sections
    document.querySelectorAll('.dashboard-section').forEach(section => {
        section.classList.remove('active');
    });
    document.getElementById(tabId + '-section').classList.add('active');

    // Load section-specific data
    if (tabId === 'employees') {
        loadEmployeeCharts();
    } else if (tabId === 'leave') {
        loadLeaveCharts();
    }
}
