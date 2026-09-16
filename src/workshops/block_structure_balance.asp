<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Block Structure (Balance Model)</title>
    <meta name="description" content="Understanding Balance Model with Alice → Bob transaction in a fork scenario">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body { transition: background-color 0.1s, color 0.1s; }
        .utxoTable {
            font-family: 'Courier New', monospace;
            border-collapse: collapse;
            margin: 20px auto;
            width: 100%;
            max-width: 1200px;
        }
        .utxoTable th, .utxoTable td {
            padding: 10px;
            text-align: center;
            vertical-align: middle;
            border: 1px solid #555;
        }
        .input-container {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 4px;
            gap: 8px;
        }
        input[type="text"], input {
            font-family: 'Courier New', monospace;
            padding: 4px;
            width: 80px;
        }
        .control-btn {
            font-family: 'Courier New', monospace;
            padding: 2px 6px;
            cursor: pointer;
            margin: 0 2px;
        }
        .value-cell {
            background-color: transparent;
            transition: all 0.3s;
            font-size: 1.1em;
        }
        .highlight {
            font-weight: bold;
            animation: fadeGreen 2.8s ease-out forwards;
            color: #00ff9d !important;
            text-shadow: 0 0 8px #00ff9d;
        }
        .invalid {
            color: #ff6666 !important;
            text-shadow: 0 0 8px #ff0000;
            animation: shake 0.4s;
        }
        .timestamp-highlight {
            animation: fadeGreen 2.5s ease-out forwards;
            color: #90ee90 !important;
        }
        @keyframes fadeGreen {
            0% { background-color: #90ee90; color: #004d26 !important; }
            100% { background-color: transparent; }
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }
        .miner-header { background-color: #333; color: white; }
        .timestamp {
            font-size: 0.85em;
            color: #aaa;
            margin-top: 6px;
        }
        .decimal-value {
            font-weight: bold;
            margin: 4px 0;
            color: #ddd;
        }
    </style>
</head>
<body class="dark-mode">

    <header>
        <h1>Block Structure (Balance Model)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/block_structure_balance.asp">Block Structure (Balance Model)</a>
    </section>

    <main>
        <section class="content-box">
            <h2>Alice to Bob Transaction (Simple Fork Scenario)</h2>
            <p>Change Alice's transaction amount per nonce. Each block fork updates independently.</p>
        </section>

        <!-- Top Balances -->
        <table border="1" class="utxoTable">
            <tr>
                <th>Alice's Initial Nonce</th>
                <th>Alice's Remaining Balance</th>
                <th>Bob's Remaining Balance</th>
            </tr>
            <tr>
                <td id="aliceTopNonce"><strong>12</strong></td>
                <td id="aliceTopBalance"><strong>124</strong></td>
                <td id="bobTopBalance"><strong>85</strong></td>
            </tr>
        </table>

        <div id="BlocksContainer"></div>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok for helping build this Balance Model teaching tool.</p>
        </section>
    </main>

<script>
    const NUM_BlockS = 3;
    let ALICE_START_NONCE;
    let ALICE_START_BALANCE;
    let BOB_START_BALANCE;

    function randomBalance(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function binaryToDecimal(binary) {
        return parseInt(binary.toString().padStart(7, '0'), 2);
    }

    function increment(id) {
        const input = document.getElementById(id);
        let val = binaryToDecimal(input.value);
        val = (val + 1) % 128;
        input.value = val.toString(2).padStart(7, '0');
        calculateBlock(id.split('_')[1]);
    }

    function decrement(id) {
        const input = document.getElementById(id);
        let val = binaryToDecimal(input.value);
        if (val > 0) {
            val = (val - 1);
            input.value = val.toString(2).padStart(7, '0');
            calculateBlock(id.split('_')[1]);
        }
    }

    function getNextNonce() {
        //return Math.floor(Date.now() / 1000);
		return ++ALICE_START_NONCE;
    }

    function createBlocks() {
        const container = document.getElementById('BlocksContainer');
        container.innerHTML = '';

        for (let g = 1; g <= NUM_BlockS; g++) {
            const table = document.createElement('table');
            table.border = "1";
            table.className = "utxoTable";

            let html = `
                <tr>
                    <th colspan="3" class="miner-header">Miner ${g} (Block 17)</th>
                </tr>
                <tr>
                    <th>Alice's Raw Transaction</th>
                    <th>Alice's New Balance</th>
                    <th>Bob's New Balance</th>
                </tr>
                <tr>
                    <td>
                        <div class="input-container">
                            <input id="aliceRaw_${g}" value="0000000" maxlength="7" data-Block="${g}">
                            <button class="control-btn" onclick="increment('aliceRaw_${g}')">+</button>
                            <button class="control-btn" onclick="decrement('aliceRaw_${g}')">-</button>
                        </div>
                        <div class="decimal-value" id="decimal_${g}">(0)</div>
                        <div class="timestamp" id="nonce_${g}">Nonce: 0</div>
                    </td>
                    <td class="value-cell" id="aliceNew_${g}"><strong>${ALICE_START_BALANCE}</strong></td>
                    <td class="value-cell" id="bobNew_${g}"><strong>${BOB_START_BALANCE}</strong></td>
                </tr>
            `;

            table.innerHTML = html;
            container.appendChild(table);
        }
    }

    function calculateBlock(BlockNum) {
        const rawInput = document.getElementById(`aliceRaw_${BlockNum}`);
        const rawVal = binaryToDecimal(rawInput.value);
        const decimalEl = document.getElementById(`decimal_${BlockNum}`);

        decimalEl.textContent = `(${rawVal})`;

        // Timestamp
        const tsEl = document.getElementById(`nonce_${BlockNum}`);
        tsEl.textContent = `Nonce: ${getNextNonce()}`;
        tsEl.classList.remove('timestamp-highlight');
        void tsEl.offsetWidth;
        tsEl.classList.add('timestamp-highlight');

        const aliceCell = document.getElementById(`aliceNew_${BlockNum}`);
        const bobCell = document.getElementById(`bobNew_${BlockNum}`);

        if (rawVal > ALICE_START_BALANCE) {
            // Invalid state
            aliceCell.innerHTML = `<strong>Insufficient</strong>`;
            aliceCell.classList.add('invalid');
            bobCell.innerHTML = `<strong>0</strong>`;
            bobCell.classList.remove('highlight');
        } else {
            // Valid
            const aliceNew = ALICE_START_BALANCE - rawVal;
            const bobNew = BOB_START_BALANCE + rawVal;

            aliceCell.innerHTML = `<strong>${aliceNew}</strong>`;
            aliceCell.classList.remove('invalid');
            aliceCell.classList.add('highlight');

            bobCell.innerHTML = `<strong>${bobNew}</strong>`;
            bobCell.classList.remove('invalid');
            bobCell.classList.add('highlight');
        }

        highlightMatchingLastDigits();
    }

    function highlightMatchingLastDigits() {
        const cells = document.querySelectorAll('#BlocksContainer .value-cell strong');
        const digitMap = {};

        cells.forEach(cell => {
            const num = parseInt(cell.textContent) || 0;
            const digit = num % 10;
            if (!digitMap[digit]) digitMap[digit] = [];
            digitMap[digit].push(cell.parentElement);
        });

        Object.values(digitMap).forEach(group => {
            if (group.length > 1) {
                group.forEach(td => td.classList.add('highlight'));
            }
        });
    }

    window.onload = function() {
        // Random initial balances
		ALICE_START_NONCE = randomBalance(1, 60);
        ALICE_START_BALANCE = randomBalance(60, 127);
        BOB_START_BALANCE = randomBalance(40, 127);

        document.getElementById('aliceTopNonce').innerHTML = `<strong>${ALICE_START_NONCE}</strong>`;
        document.getElementById('aliceTopBalance').innerHTML = `<strong>${ALICE_START_BALANCE}</strong>`;
        document.getElementById('bobTopBalance').innerHTML = `<strong>${BOB_START_BALANCE}</strong>`;

        createBlocks();
    };

    function toggleDarkMode() {
        document.body.classList.toggle('dark-mode');
    }
</script>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>