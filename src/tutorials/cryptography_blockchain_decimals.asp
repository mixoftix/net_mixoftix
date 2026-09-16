<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decimal Standards for Blockchain Transactions</title>
    <meta name="description" content="Comprehensive guide to implementing decimal standards for cryptocurrency transactions across SQL Server, C#, Android/Java, Python, and JavaScript platforms">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

	<style>
		/* Default styles for light mode (when dark-mode class is not applied) */
		pre {
			background-color: #f5f5f5; /* Light grayish-white background for light mode */
			color: #333333; /* Dark gray text for contrast */
			padding: 15px;
			border-radius: 8px;
			overflow-x: auto;
			font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
			font-size: 0.9em;
		}
		pre code .keyword {
			color: #d32f2f; /* Darker pinkish-red for keywords in light mode */
		}
		pre code .string {
			color: #388e3c; /* Darker green for strings in light mode */
		}
		pre code .comment {
			color: #388e3c; /* Darker green for comments in light mode */
		}
	
		/* Override styles for dark mode (when dark-mode class is applied to body) */
		body.dark-mode pre {
			background-color: #1e2226; /* Dark gray background for dark mode */
			color: #d4d4d4; /* Light gray text for dark mode */
		}
		body.dark-mode pre code .keyword {
			color: #f44747; /* Pinkish-red for keywords in dark mode */
		}
		body.dark-mode pre code .string {
			color: #6a8759; /* Green for strings in dark mode */
		}
		body.dark-mode pre code .comment {
			color: #6a8759; /* Green for comments in dark mode */
		}
	</style>

</head>
<body class="dark-mode">
    <header>
        <h1>Decimal Standards for Blockchain Transactions</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Tutorials /
        <a href="cryptography_blockchain_decimals.asp">Cryptography, Blockchain, Decimals</a>
    </section>

    <main>
        <!-- Introduction Section -->
        <section class="content-box">
            <h2>Decimal Standards Fundamentals</h2>
            <p>This guide explores the proper data types and formatting for handling transaction amounts in cryptocurrency blockchain systems, focusing on SQL Server, C#, Android/Java, Python, and JavaScript platforms. The key challenge is ensuring precision, scale, and accuracy in financial calculations to prevent rounding errors in blockchain transactions.</p>
            
            <div class="cyan-box">
                <h3>Key Considerations</h3>
                <ul>
                    <li><strong>Precision:</strong> Cryptocurrencies often require high decimal precision (e.g., Bitcoin uses 8 decimal places).</li>
                    <li><strong>Scale:</strong> Values can range from tiny fractions to large whole amounts.</li>
                    <li><strong>Accuracy:</strong> Financial calculations must avoid floating-point rounding errors.</li>
                </ul>
            </div>
            <br>
            
            <div class="red-box">
                <h3>Critical Vulnerabilities with Incorrect Data Types</h3>
                <ol>
                    <li><strong>Floating-Point Errors:</strong> Using FLOAT can lead to rounding errors, causing discrepancies in transaction amounts (e.g., 0.1 + 0.2 might result in 0.30000004 instead of 0.3).</li>
                    <li><strong>Precision Loss:</strong> Insufficient decimal places can truncate small fractions, critical for cryptocurrencies like Ethereum (1 ETH = 10^18 wei).</li>
                    <li><strong>Data Transfer Issues:</strong> String formatting without parameterization can alter precision between systems.</li>
                </ol>
            </div>
            <br>
            
            <div class="gray-box">
                <h3>Recommended Data Types</h3>
                <p>For SQL Server, use <strong>DECIMAL(18,8)</strong> (18 total digits, 8 after the decimal point) to handle most cryptocurrency needs. In C#, use the <strong>decimal</strong> type, which supports 28-29 significant digits and matches SQL Server’s DECIMAL for precision. For Android/Java, use <strong>BigDecimal</strong> to ensure exact precision, formatting to 8 decimal places before signing transactions. Python and JavaScript also require careful handling to maintain precision, often using specialized libraries or string representations.</p>
                <p>These choices ensure exact numeric representation, sufficient scale, and safe data transfer between database and application, avoiding floating-point issues.</p>
            </div>
        </section>

        <!-- Implementation Guide -->
        <section class="content-box">
            <h2>Cross-Platform Implementation</h2>
            
            <div class="gray-box">
                <h3>SQL Server: Table Definition</h3>
                <pre>
<code>
-- SQL Server table
CREATE TABLE Transactions (
    TransactionId BIGINT PRIMARY KEY,
    Amount DECIMAL(18,8) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    WalletAddress VARCHAR(100),
    CONSTRAINT CHK_Amount_Positive CHECK (Amount >= 0)
);

-- Insert sample data
INSERT INTO Transactions (TransactionId, Amount, WalletAddress)
VALUES 
    (1001, 123.45678912, '0x1234...'),
    (1002, 0.00050000, '0x5678...'),
    (1003, 5000.25000000, '0x9abc...');
</code>
                </pre>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    DECIMAL(18,8) ensures 8 decimal places of precision, suitable for most cryptocurrencies like Bitcoin.
                </div>
            </div>
            <br>

            <div class="gray-box">
                <h3>C#: Parameterized Queries</h3>
                <p>This example shows a complete C# implementation for managing cryptocurrency transactions with parameterized queries to maintain precision.</p>
                <pre>
<code>
<span class="keyword">using</span> System;
<span class="keyword">using</span> System.Data.SqlClient;

<span class="keyword">public class</span> TransactionRepository
{
    <span class="keyword">private readonly string</span> connectionString = <span class="string">"your_connection_string_here"</span>;

    <span class="keyword">public void</span> CreateTransaction(<span class="keyword">long</span> transactionId, <span class="keyword">decimal</span> amount, <span class="keyword">string</span> walletAddress)
    {
        <span class="keyword">string</span> query = @<span class="string">"
            INSERT INTO Transactions (TransactionId, Amount, WalletAddress)
            VALUES (@TransactionId, @Amount, @WalletAddress)"</span>;

        <span class="keyword">using</span> (SqlConnection conn = <span class="keyword">new</span> SqlConnection(connectionString))
        <span class="keyword">using</span> (SqlCommand cmd = <span class="keyword">new</span> SqlCommand(query, conn))
        {
            cmd.Parameters.Add(<span class="string">"@TransactionId"</span>, SqlDbType.BigInt).Value = transactionId;
            cmd.Parameters.Add(<span class="string">"@Amount"</span>, SqlDbType.Decimal).Value = amount;
            cmd.Parameters[<span class="string">"@Amount"</span>].Precision = 18;
            cmd.Parameters[<span class="string">"@Amount"</span>].Scale = 8;
            cmd.Parameters.Add(<span class="string">"@WalletAddress"</span>, SqlDbType.VarChar, 100).Value = walletAddress;

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    <span class="keyword">public decimal</span> GetTransactionAmount(<span class="keyword">long</span> transactionId)
    {
        <span class="keyword">string</span> query = <span class="string">"SELECT Amount FROM Transactions WHERE TransactionId = @TransactionId"</span>;

        <span class="keyword">using</span> (SqlConnection conn = <span class="keyword">new</span> SqlConnection(connectionString))
        <span class="keyword">using</span> (SqlCommand cmd = <span class="keyword">new</span> SqlCommand(query, conn))
        {
            cmd.Parameters.Add(<span class="string">"@TransactionId"</span>, SqlDbType.BigInt).Value = transactionId;

            conn.Open();
            <span class="keyword">object</span> result = cmd.ExecuteScalar();
            <span class="keyword">return</span> result != <span class="keyword">null</span> ? Convert.ToDecimal(result) : 0m;
        }
    }

    <span class="keyword">public void</span> UpdateTransactionAmount(<span class="keyword">long</span> transactionId, <span class="keyword">decimal</span> newAmount)
    {
        <span class="keyword">string</span> query = <span class="string">"UPDATE Transactions SET Amount = @Amount WHERE TransactionId = @TransactionId"</span>;

        <span class="keyword">using</span> (SqlConnection conn = <span class="keyword">new</span> SqlConnection(connectionString))
        <span class="keyword">using</span> (SqlCommand cmd = <span class="keyword">new</span> SqlCommand(query, conn))
        {
            cmd.Parameters.Add(<span class="string">"@Amount"</span>, SqlDbType.Decimal).Value = newAmount;
            cmd.Parameters[<span class="string">"@Amount"</span>].Precision = 18;
            cmd.Parameters[<span class="string">"@Amount"</span>].Scale = 8;
            cmd.Parameters.Add(<span class="string">"@TransactionId"</span>, SqlDbType.BigInt).Value = transactionId;

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    <span class="keyword">public decimal</span> GetWalletBalance(<span class="keyword">string</span> walletAddress)
    {
        <span class="keyword">string</span> query = <span class="string">"SELECT SUM(Amount) FROM Transactions WHERE WalletAddress = @WalletAddress"</span>;

        <span class="keyword">using</span> (SqlConnection conn = <span class="keyword">new</span> SqlConnection(connectionString))
        <span class="keyword">using</span> (SqlCommand cmd = <span class="keyword">new</span> SqlCommand(query, conn))
        {
            cmd.Parameters.Add(<span class="string">"@WalletAddress"</span>, SqlDbType.VarChar, 100).Value = walletAddress;

            conn.Open();
            <span class="keyword">object</span> result = cmd.ExecuteScalar();
            <span class="keyword">return</span> result != <span class="keyword">null</span> ? Convert.ToDecimal(result) : 0m;
        }
    }
}

<span class="comment">// Usage example</span>
<span class="keyword">public class</span> Program
{
    <span class="keyword">static void</span> Main()
    {
        <span class="keyword">var</span> repo = <span class="keyword">new</span> TransactionRepository();

        <span class="comment">// Create a transaction</span>
        repo.CreateTransaction(1001, 123.45678912m, <span class="string">"0x1234..."</span>);

        <span class="comment">// Get amount</span>
        <span class="keyword">decimal</span> amount = repo.GetTransactionAmount(1001);
        Console.WriteLine($<span class="string">"Amount: {amount}"</span>);

        <span class="comment">// Update amount</span>
        repo.UpdateTransactionAmount(1001, 150.75000000m);

        <span class="comment">// Get wallet balance</span>
        <span class="keyword">decimal</span> balance = repo.GetWalletBalance(<span class="string">"0x1234..."</span>);
        Console.WriteLine($<span class="string">"Balance: {balance}"</span>);
    }
}
</code>
                </pre>
                <br>
                <div class="green-box">
                    <strong>Sample Input:</strong><br>
                    Transaction ID: 1001<br>
                    Amount: 123.45678912<br>
                    Wallet Address: 0x1234...
                </div>
                <br>
                <div class="green-box">
                    <strong>Sample Output:</strong><br>
                    Amount: 123.45678912<br>
                    Balance: 123.45678912 (after creation)
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Notes:</strong><br>
                    - Always use parameterized queries to prevent SQL injection and maintain precision.<br>
                    - Specify precision and scale to match the database schema.<br>
                    - Avoid string concatenation to prevent formatting issues.
                </div>
            </div>
            <br>

            <div class="gray-box">
                <h3>Android/Java: Formatting Transaction Amount</h3>
                <p>This example demonstrates the best approach for formatting transaction amounts in Android/Java using <code>BigDecimal</code> to ensure exact precision before signing.</p>
                <pre>
<code>
<span class="keyword">import</span> java.math.BigDecimal;
<span class="keyword">import</span> java.math.RoundingMode;

<span class="keyword">public class</span> TransactionFormatter {
    <span class="keyword">public static</span> String formatTransactionAmount(String str_amount) {
        <span class="keyword">try</span> {
            <span class="comment">// Use BigDecimal for exact precision</span>
            BigDecimal amount = <span class="keyword">new</span> BigDecimal(str_amount);
            <span class="comment">// Set scale to 8 decimal places, round if necessary</span>
            amount = amount.setScale(8, RoundingMode.HALF_UP);
            <span class="comment">// Convert to string without scientific notation</span>
            <span class="keyword">return</span> amount.toPlainString();
        } <span class="keyword">catch</span> (NumberFormatException e) {
            <span class="keyword">throw new</span> IllegalArgumentException(<span class="string">"Invalid amount format: "</span> + str_amount, e);
        }
    }

    <span class="keyword">public static void</span> main(String[] args) {
        String str_amount = <span class="string">"123.45678912345"</span>;
        String formatted = formatTransactionAmount(str_amount);
        System.out.println(<span class="string">"Formatted Amount: "</span> + formatted);
    }
}
</code>
                </pre>
                <br>
                <div class="green-box">
                    <strong>Sample Input:</strong><br>
                    str_amount: "123.45678912345"
                </div>
                <br>
                <div class="green-box">
                    <strong>Sample Output:</strong><br>
                    Formatted Amount: "123.45678912"
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Notes:</strong><br>
                    - <code>BigDecimal</code> ensures exact precision, avoiding floating-point issues.<br>
                    - Use <code>RoundingMode.HALF_UP</code> for consistent rounding behavior.<br>
                    - Validate the formatted string before signing the transaction.
                </div>
            </div>
            <br>

            <div class="gray-box">
                <h3>Python: Formatting Transaction Amount</h3>
                <p>This example demonstrates formatting transaction amounts in Python using the <code>decimal</code> module to ensure exact precision for blockchain transactions.</p>
                <pre>
<code>
<span class="keyword">from</span> decimal <span class="keyword">import</span> Decimal, ROUND_HALF_UP

<span class="keyword">def</span> format_transaction_amount(str_amount):
    <span class="keyword">try</span>:
        <span class="comment"># Use Decimal for exact precision</span>
        amount = Decimal(str_amount)
        <span class="comment"># Set scale to 8 decimal places, round if necessary</span>
        amount = amount.quantize(Decimal('0.00000001'), rounding=ROUND_HALF_UP)
        <span class="comment"># Convert to string without scientific notation</span>
        <span class="keyword">return</span> str(amount)
    <span class="keyword">except</span> ValueError:
        <span class="keyword">raise</span> ValueError(<span class="string">"Invalid amount format: "</span> + str_amount)

<span class="keyword">if</span> __name__ == <span class="string">"__main__"</span>:
    str_amount = <span class="string">"123.45678912345"</span>
    formatted = format_transaction_amount(str_amount)
    print(<span class="string">"Formatted Amount:"</span>, formatted)
</code>
                </pre>
                <br>
                <div class="green-box">
                    <strong>Sample Input:</strong><br>
                    str_amount: "123.45678912345"
                </div>
                <br>
                <div class="green-box">
                    <strong>Sample Output:</strong><br>
                    Formatted Amount: "123.45678912"
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Notes:</strong><br>
                    - Python’s <code>decimal</code> module ensures exact precision, avoiding floating-point issues.<br>
                    - Use <code>ROUND_HALF_UP</code> for consistent rounding.<br>
                    - Avoid using <code>float</code> (e.g., <code>float(str_amount)</code>) to prevent precision loss.
                </div>
                <p><strong>Reference:</strong> <a href="https://docs.python.org/3/library/decimal.html" target="_blank">Python decimal Module Documentation</a></p>
            </div>
            <br>

            <div class="gray-box">
                <h3>JavaScript: Formatting Transaction Amount</h3>
                <p>This example demonstrates formatting transaction amounts in JavaScript using the <code>big.js</code> library to ensure exact precision for blockchain transactions, as JavaScript’s native numbers are floating-point and prone to precision errors.</p>
                <pre>
<code>
<span class="keyword">const</span> Big = require(<span class="string">'big.js'</span>);

<span class="keyword">function</span> formatTransactionAmount(str_amount) {
    <span class="keyword">try</span> {
        <span class="comment">// Use Big.js for exact precision</span>
        <span class="keyword">const</span> amount = <span class="keyword">new</span> Big(str_amount);
        <span class="comment">// Set scale to 8 decimal places, round if necessary</span>
        <span class="keyword">return</span> amount.toFixed(8);
    } <span class="keyword">catch</span> (e) {
        <span class="keyword">throw new</span> Error(<span class="string">"Invalid amount format: "</span> + str_amount);
    }
}

<span class="comment">// Usage example</span>
<span class="keyword">const</span> str_amount = <span class="string">"123.45678912345"</span>;
<span class="keyword">const</span> formatted = formatTransactionAmount(str_amount);
console.log(<span class="string">"Formatted Amount:"</span>, formatted);
</code>
                </pre>
                <br>
                <div class="green-box">
                    <strong>Sample Input:</strong><br>
                    str_amount: "123.45678912345"
                </div>
                <br>
                <div class="green-box">
                    <strong>Sample Output:</strong><br>
                    Formatted Amount: "123.45678912"
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Notes:</strong><br>
                    - JavaScript’s native numbers are floating-point (e.g., 0.1 + 0.2 = 0.30000000000000004), so use a library like <code>big.js</code> or <code>decimal.js</code> for precision.<br>
                    - Avoid using <code>parseFloat</code> or <code>Number</code> directly for cryptocurrency amounts.<br>
                    - Install <code>big.js</code> via npm: <code>npm install big.js</code>.
                </div>
                <p><strong>Reference:</strong> <a href="https://github.com/MikeMcl/big.js" target="_blank">big.js Library Documentation</a></p>
            </div>
        </section>

        <!-- Comparison Tables -->
        <section class="content-box">
            <h2>Platform Comparison</h2>
            
            <div class="cyan-box">
                <h3>Decimal Support Matrix</h3>
                <table border="0" cellpadding="5" cellspacing="5" style="width:100%">
                    <tr>
                        <th>Platform</th>
                        <th>Recommended Type</th>
                        <th>Precision</th>
                        <th>Scale</th>
                    </tr>
                    <tr>
                        <td>SQL Server</td>
                        <td>DECIMAL</td>
                        <td>18 digits</td>
                        <td>8 decimal places</td>
                    </tr>
                    <tr>
                        <td>C#</td>
                        <td>decimal</td>
                        <td>28-29 digits</td>
                        <td>Matches DECIMAL</td>
                    </tr>
                    <tr>
                        <td>Android/Java</td>
                        <td>BigDecimal</td>
                        <td>Arbitrary (set to 8)</td>
                        <td>8 decimal places</td>
                    </tr>
                    <tr>
                        <td>Python</td>
                        <td>decimal.Decimal</td>
                        <td>Arbitrary (set to 8)</td>
                        <td>8 decimal places</td>
                    </tr>
                    <tr>
                        <td>JavaScript</td>
                        <td>big.js</td>
                        <td>Arbitrary (set to 8)</td>
                        <td>8 decimal places</td>
                    </tr>
                </table>
            </div>
            <br>

            <div class="gray-box">
                <h3>Data Type Comparison</h3>
                <table border="0" cellpadding="5" cellspacing="5" style="width:100%">
                    <tr>
                        <th>Type</th>
                        <th>Precision</th>
                        <th>Storage</th>
                        <th>Usage</th>
                    </tr>
                    <tr>
                        <td>DECIMAL(18,8)</td>
                        <td>18 digits, 8 decimal places</td>
                        <td>9 bytes</td>
                        <td>Blockchain transactions</td>
                    </tr>
                    <tr>
                        <td>FLOAT</td>
                        <td>Approximate, ~15 digits</td>
                        <td>4-8 bytes</td>
                        <td>Scientific calculations (avoid for finance)</td>
                    </tr>
                </table>
            </div>
        </section>

        <!-- Additional Resources -->
        <section class="content-box">
            <h2>Additional Resources</h2>
            
            <div class="cyan-box">
                <h3>Reference Implementations</h3>
                <ul>
                    <li><a href="https://docs.microsoft.com/en-us/sql/t-sql/data-types/decimal-and-numeric-transact-sql" target="_blank">SQL Server DECIMAL Documentation</a></li>
                    <li><a href="https://docs.microsoft.com/en-us/dotnet/api/system.decimal" target="_blank">C# decimal Documentation</a></li>
                    <li><a href="https://docs.oracle.com/javase/8/docs/api/java/math/BigDecimal.html" target="_blank">Java BigDecimal Documentation</a></li>
                    <li><a href="https://docs.python.org/3/library/decimal.html" target="_blank">Python decimal Module Documentation</a></li>
                    <li><a href="https://github.com/MikeMcl/big.js" target="_blank">big.js Library Documentation</a></li>
                </ul>
            </div>
            <br>
            
            <div class="cyan-box">
                <h3>Further Reading</h3>
                <ul>
                    <li><a href="https://bitcoin.org/en/developer-guide#blockchain" target="_blank">Bitcoin Developer Guide: Blockchain Transactions</a></li>
                    <li><a href="https://ethereum.org/en/developers/docs/" target="_blank">Ethereum Developer Documentation</a></li>
                    <li><a href="https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency" target="_blank">Stack Overflow: Why Not Use Float for Currency</a></li>
                </ul>
            </div>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this tutorial for blockchain transactions.</p>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->