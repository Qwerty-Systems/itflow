<?php include("header.php"); ?>

<?php
//Get Total income Do not grab transfer payment as these have an invoice_id of 0
$sql_total_income = mysqli_query($mysqli,"SELECT SUM(payment_amount) AS total_income FROM payments WHERE invoice_id > 0");
$row = mysqli_fetch_array($sql_total_income);
$total_income = $row['total_income'];

//Get Total expenses and do not grab transfer expenses as these have a vendor of 0
$sql_total_expenses = mysqli_query($mysqli,"SELECT SUM(expense_amount) AS total_expenses FROM expenses WHERE vendor_id > 0");
$row = mysqli_fetch_array($sql_total_expenses);
$total_expenses = $row['total_expenses'];

//Total up all the 
$sql_invoice_totals = mysqli_query($mysqli,"SELECT SUM(invoice_amount) AS invoice_totals FROM invoices WHERE invoice_status NOT LIKE 'Draft'");
$row = mysqli_fetch_array($sql_invoice_totals);
$invoice_totals = $row['invoice_totals'];

$recievables = $invoice_totals - $total_income; 

$profit = $total_income - $total_expenses;

$sql_accounts = mysqli_query($mysqli,"SELECT * FROM accounts ORDER BY account_id DESC");

$sql_latest_income_payments = mysqli_query($mysqli,"SELECT * FROM payments, invoices, clients 
	WHERE payments.invoice_id = invoices.invoice_id 
	AND invoices.client_id = clients.client_id 
	ORDER BY payment_id DESC LIMIT 5"
);

$sql_latest_expenses = mysqli_query($mysqli,"SELECT * FROM expenses, vendors, categories 
	WHERE expenses.vendor_id = vendors.vendor_id 
	AND expenses.category_id = categories.category_id
	ORDER BY expense_id DESC LIMIT 5"
);

?>

<!-- Icon Cards-->
<div class="row">
  <div class="col-xl-4 col-sm-6 mb-3">
    <div class="card text-white bg-primary o-hidden h-100">
      <div class="card-body">
        <div class="card-body-icon">
          <i class="fas fa-fw fa-money-check"></i>
        </div>
        <div class="mr-5">Total Incomes <h1>$<?php echo number_format($total_income,2); ?></h1></div>
        <hr>
        Recievables: $<?php echo number_format($recievables,2); ?>
      </div>
    </div>
  </div>
  <div class="col-xl-4 col-sm-6 mb-3">
    <div class="card text-white bg-danger o-hidden h-100">
      <div class="card-body">
        <div class="card-body-icon">
          <i class="fas fa-fw fa-shopping-cart"></i>
        </div>
        <div class="mr-5">Total Expenses <h1>$<?php echo number_format($total_expenses,2); ?></h1></div>
      </div>      
    </div>
  </div>
  <div class="col-xl-4 col-sm-6 mb-3">
    <div class="card text-white bg-success o-hidden h-100">
      <div class="card-body">
        <div class="card-body-icon">
          <i class="fas fa-fw fa-heart"></i>
        </div>
        <div class="mr-5">Total Profit <h1>$<?php echo number_format($profit,2); ?></h1></div>
      </div>
    </div>
  </div> 
</div>

  <!-- Area Chart Example-->
  <div class="card mb-3">
    <div class="card-header">
      <i class="fas fa-chart-area"></i>
      Cash Flow</div>
    <div class="card-body">
      <canvas id="myAreaChart" width="100%" height="30"></canvas>
    </div>
    <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
  </div>

  <!-- DataTables Example -->
  <div class="row mb-3">
    <div class="col-md-4">
      <div class="card">
        <div class="card-header">Account Balance</div>
          <div class="table-responsive">
            <table class="table table-borderless">
              <tbody>
              	<?php
              	while($row = mysqli_fetch_array($sql_accounts)){
			            $account_id = $row['account_id'];
			            $account_name = $row['account_name'];
			            $opening_balance = $row['opening_balance'];

			          ?>
                <tr>
			            <td><?php echo $account_name; ?></a></td>
			            <?php
			            $sql2 = mysqli_query($mysqli,"SELECT SUM(payment_amount) AS total_payments FROM payments WHERE account_id = $account_id");
			            $row2 = mysqli_fetch_array($sql2);
			            
			            $sql3 = mysqli_query($mysqli,"SELECT SUM(expense_amount) AS total_expenses FROM expenses WHERE account_id = $account_id");
			            $row3 = mysqli_fetch_array($sql3);
			            
			            $balance = $opening_balance + $row2['total_payments'] - $row3['total_expenses'];
			            if($balance == ''){
			              $balance = '0.00'; 
			            }
			            ?>

			            <td class="text-right text-monospace">$<?php echo number_format($balance,2); ?></td>
			          </tr>
			          <?php
			        	}
			        	?>

              </tbody>
            </table>
          </div>
      </div>
    </div> <!-- .col -->
    <div class="col-md-4">
      <div class="card">
        <div class="card-header">
          Latest Payments
        </div>
        <div class="table-responsive">
          <table class="table table-borderless">
            <thead>
              <tr>
                <th>Date</th>
                <th>Customer</th>
                <th>Invoice</th>
                <th class="text-right">Amount</th>
              </tr>
            </thead>
            <tbody>
              <?php
            	while($row = mysqli_fetch_array($sql_latest_income_payments)){
		            $payment_date = $row['payment_date'];
		            $payment_amount = $row['payment_amount'];
		            $invoice_number = $row['invoice_number'];
		            $client_name = $row['client_name'];
			        ?>
              <tr>
                <td><?php echo $payment_date; ?></td>
                <td><?php echo $client_name; ?></td>
                <td><?php echo $invoice_number; ?></td>
                <td class="text-right text-monospace">$<?php echo number_format($payment_amount,2); ?></td>
              </tr>
              <?php
			        }
			        ?>
            </tbody>
          </table>
        </div>
      </div>
    </div> <!-- .col -->
    <div class="col-md-4">
      <div class="card">
        <div class="card-header">
          Latest Expenses
        </div>
        <div class="table-responsive">
          <table class="table table-borderless">
            <thead>
              <tr>
                <th>Date</th>
            		<th>Vendor</th>
                <th>Category</th>
                <th class="text-right">Amount</th>
              </tr>
            </thead>
            <tbody>
            	<?php
            	while($row = mysqli_fetch_array($sql_latest_expenses)){
		            $expense_date = $row['expense_date'];
		            $expense_amount = $row['expense_amount'];
		            $vendor_name = $row['vendor_name'];
		            $category_name = $row['category_name'];

			        ?>
              <tr>
                <td><?php echo $expense_date; ?></td>
                <td><?php echo $vendor_name; ?></td>
                <td><?php echo $category_name; ?></td>
                <td class="text-right text-monospace">$<?php echo number_format($expense_amount,2); ?></td>
              </tr>
             	<?php
			        }
			        ?>
            </tbody>
          </table>
        </div>
      </div>
    </div> <!-- .col -->
  </div> <!-- row -->



<?php include("footer.php"); ?>
<script>

// Set new default font family and font color to mimic Bootstrap's default styling
Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#292b2c';

// Area Chart Example
var ctx = document.getElementById("myAreaChart");
var myLineChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: ["Mar 1", "Mar 2", "Mar 3", "Mar 4", "Mar 5", "Mar 6", "Mar 7", "Mar 8", "Mar 9", "Mar 10", "Mar 11", "Mar 12", "Mar 13"],
    datasets: [{
      label: "Sessions",
      lineTension: 0.3,
      backgroundColor: "rgba(2,117,216,0.2)",
      borderColor: "rgba(2,117,216,1)",
      pointRadius: 5,
      pointBackgroundColor: "rgba(2,117,216,1)",
      pointBorderColor: "rgba(255,255,255,0.8)",
      pointHoverRadius: 5,
      pointHoverBackgroundColor: "rgba(2,117,216,1)",
      pointHitRadius: 50,
      pointBorderWidth: 2,
      data: [10000, 30162, 26263, 18394, 18287, 28682, 31274, 33259, 25849, 24159, 32651, 31984, 38451],
    }],
  },
  options: {
    scales: {
      xAxes: [{
        time: {
          unit: 'date'
        },
        gridLines: {
          display: false
        },
        ticks: {
          maxTicksLimit: 7
        }
      }],
      yAxes: [{
        ticks: {
          min: 0,
          max: 40000,
          maxTicksLimit: 5
        },
        gridLines: {
          color: "rgba(0, 0, 0, .125)",
        }
      }],
    },
    legend: {
      display: false
    }
  }
});

</script>