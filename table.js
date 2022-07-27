const tableBody = document.querySelector('#bodyKPITable')
const dataNormal = []

let dummy = '';
let allOntime = 0;
let allLate = 0;
tableBody.innerHTML = 'Loading.....'

const dataTable = async () => {
    const response  = await fetch('data.json')
    const data = await response.json()

    return data
}

const bentukObjek = (data, key) =>{
    let sales = 0
    let report = 0
    let ontime = 0
    let late = 0

    data.forEach(element => {
        const deadline = new Date(element.deadline)
        const actual = new Date(element.aktual)
        if (element.kpi === 'Sales') sales++
        if (element.kpi === 'Report') report++
        if (actual <= deadline) {
            ontime++
            allOntime++
        } else {
            allLate++
            late++
        }
    });
    const nameObj = { 
        nama: key
    }

    const salesObj = {
        sales: sales
    }
    const reportObj = {
        report: report
    }

    const ontimeObj = {
        ontime: ontime
    }

    const lateObj = {
        late: late
    }

    const finalObject = Object.assign(nameObj, salesObj, reportObj, ontimeObj, lateObj)
    dataNormal.push(finalObject)
    // console.log(finalObject);
    tampilData(finalObject)
}

const tampilData = (dataNormal) =>{
    const target = 2
    const {nama, sales, report} = dataNormal
    const pencapaianSales = sales/target*100
    const actualBobotSales= pencapaianSales*0.5
    const pencapaianReport = report/target*100
    const actualBobotReport= pencapaianReport*0.5
    const KPI = actualBobotReport+actualBobotSales
    dummy += `
        <tr>
            <td>${nama}</td>
            <td>${target}</td>
            <td>${sales}</td>
            <td>${pencapaianSales}%</td>
            <td>${actualBobotSales}%</td>
            <td>${target}</td>
            <td>${report}</td>
            <td>${pencapaianReport}%</td>
            <td>${actualBobotReport}%</td>
            <td>${KPI}%</td>
        </tr>
    `
    tableBody.innerHTML = dummy
}

const tampilPieChart = (ontime, late) =>{
    const ctx = document.querySelector(".pieChart")
    const pieChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels :['Ontime', 'Late'],
            datasets: [{
                data: [ontime, late],
                backgroundColor: [
                    'rgba(54, 162, 235)',
                    '#eee',
                ],
                borderColor:['#bbb','rgba(54, 162, 235, 1)']
            }]
        },
        options: {
            responsive: true,
        }
    })
}

const tampilStackedChart = (dataNormal) => {
    const nama = []
    const late = []
    const ontime = []
    dataNormal.forEach(element=>{
        nama.push(element.nama)
        late.push(element.late)
        ontime.push(element.ontime)
    })

    console.log(late);
    const ctx = document.querySelector(".stackedChart")
    const stackedChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: nama,
            datasets: [
                {
                    label: 'Ontime',
                    backgroundColor: 'rgba(54, 162, 235)',
                    data: ontime
                },
                {
                    label: 'Late',
                    backgroundColor: '#bbb',
                    data: late
                }
            ]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            scales: {
                x: {
                    stacked: true
                },
                y: {
                    stacked: true
                }
            },
        }
    })
}

dataTable()
.then(value=>{
    const dataKPI = value.kpiData
    const groupByKaryawan = dataKPI.reduce((group, kpi) =>{
        const {karyawan} = kpi
        group[karyawan] = group[karyawan] ?? []
        group[karyawan].push(kpi)
        return group
    }, {})
    // console.log(groupByKaryawan)
    for (const key in groupByKaryawan) {
        // console.log(groupByKaryawan[key])
        bentukObjek(groupByKaryawan[key], key)
    }
    tampilPieChart(allOntime, allLate)
    tampilStackedChart(dataNormal)
})