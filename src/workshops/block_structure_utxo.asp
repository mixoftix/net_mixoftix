<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Block Structure (UTXO Model)</title>
    <meta name="description" content="Understanding UTXO with Alice → Bob transaction in a fork scenario">
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
            transition: background-color 0.2s;
        }
        .highlight {
            color: black !important;
            font-weight: bold;
            animation: fadeGreen 2.5s ease-out forwards;
        }
        @keyframes fadeGreen {
            0% { background-color: #90ee90; }
            100% { background-color: transparent; }
        }
        .miner-header { background-color: #333; color: white; }
        .utxo-list { text-align: left; padding: 8px; }
        .new-utxos { display: flex; flex-direction: column; gap: 6px; align-items: center; font-size: 0.95em; }
    </style>
</head>
<body class="dark-mode">

    <header>
        <h1>Block Structure (UTXO Model)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/block_structure_utxo.asp">Block Structure (UTXO Model)</a>
    </section>

    <main>
        <section class="content-box">
            <h2>Alice to Bob Transaction (Simple Fork Scenario)</h2>
            <p>Change Alice's Raw Transaction. Check / uncheck Alice's UTXOs per miner. Watch how new unspent outputs are created for Alice (change) and Bob.</p>
        </section>

        <!-- Alice Raw Transaction -->
        <table border="1" class="utxoTable">
            <tr>
                <th>Alice Raw Transaction</th>
                <th>Bob's Unspent Transactions</th>
            </tr>
            <tr>
                <td>
                    <div class="input-container">
                        <input id="aliceRaw" value="0000000" maxlength="7">
                        <button class="control-btn" onclick="increment('aliceRaw')">+</button>
                        <button class="control-btn" onclick="decrement('aliceRaw')">-</button>
                        <span id="aliceDecimal" style="margin-left:12px; font-weight:bold;">(0)</span>
                    </div>
                </td>
                <td id="bobFixedUTXOs"></td>
            </tr>
        </table>

        <div id="minersContainer"></div>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok for helping build this UTXO + fork teaching tool.</p>
        </section>
    </main>


<script>
    const NUM_MINERS = 3;
    const NUM_ALICE_UTXOS = 5;

    function randomBinary() {
        return Array(7).fill(0).map(() => Math.floor(Math.random()*2)).join('');
    }

    function binaryToDecimal(binary) {
        return parseInt(binary.toString().padStart(7, '0'), 2);
    }

    function increment(id) {
        const input = document.getElementById(id);
        let val = binaryToDecimal(input.value);
        val = (val + 1) % 128;
        input.value = val.toString(2).padStart(7, '0');
        calculateAll();
    }

    function decrement(id) {
        const input = document.getElementById(id);
        let val = binaryToDecimal(input.value);
        val = (val - 1 + 128) % 128;
        input.value = val.toString(2).padStart(7, '0');
        calculateAll();
    }

    function generateBobFixedUTXOs() {
        const container = document.getElementById('bobFixedUTXOs');
        let html = '<div style="display:flex; flex-direction:column; gap:4px; align-items:center;">';
        for (let i = 1; i <= 3; i++) {
            const val = Math.floor(Math.random() * 50) + 10;
            html += `<div>Bob UTXO ${i}: <strong>${val}</strong></div>`;
        }
        html += '</div>';
        container.innerHTML = html;
    }

    function createMiners() {
        const container = document.getElementById('minersContainer');
        container.innerHTML = '';

        const aliceUTXOs = [];
        for (let i = 0; i < NUM_ALICE_UTXOS; i++) {
            aliceUTXOs.push(Math.floor(Math.random() * 40) + 5);
        }

        for (let m = 1; m <= NUM_MINERS; m++) {
            const table = document.createElement('table');
            table.border = "1";
            table.className = "utxoTable";

            let html = `
                <tr>
                    <th colspan="3" class="miner-header">Miner ${m} (Block 17)</th>
                </tr>
                <tr>
                    <th>Alice's UTXOs (Select)</th>
                    <th>Alice's New Unspent Transaction</th>
                    <th>Bob's New Unspent Transaction</th>
                </tr>
            `;

            // Alice's UTXOs (all unchecked by default)
            html += `<tr><td class="utxo-list">`;
            aliceUTXOs.forEach((amount, idx) => {
                html += `
                    <label style="margin:4px 0; display:block;">
                        <input type="checkbox" class="utxo-check" data-miner="${m}" data-index="${idx}" data-amount="${amount}">
                        UTXO ${idx+1}: <strong>${amount}</strong>
                    </label>`;
            });
            html += `</td>`;

            // New Unspent outputs (using nice vertical style)
            html += `
                <td class="value-cell" id="aliceNew_${m}"><div class="new-utxos" id="aliceNewList_${m}" style="display:none;"></div><div id="minerWarning_${m}" style="display:none; text-align:center; font-size:0.75em; color:#fff; background:#b00020; border-radius:4px;">Selected UTXOs do not cover <br>raw transaction.</div></td>
                <td class="value-cell" id="bobNew_${m}"><div class="new-utxos" id="bobNewList_${m}"></div></td>
            </tr>`;

            table.innerHTML = html;
            container.appendChild(table);
        }
    }

	function calculateAll() {
		const rawVal = binaryToDecimal(document.getElementById('aliceRaw').value);
		document.getElementById('aliceDecimal').textContent = `(${rawVal})`;
	
		for (let m = 1; m <= NUM_MINERS; m++) {
			const checkedBoxes = document.querySelectorAll(`.utxo-check[data-miner="${m}"]:checked`);
			let totalSelected = 0;
			checkedBoxes.forEach(cb => {
				totalSelected += parseInt(cb.dataset.amount);
			});
	
			let aliceChange = totalSelected - rawVal;
			let bobReceive = rawVal;
	
			const warn = document.getElementById(`minerWarning_${m}`);
			const alic = document.getElementById(`aliceNewList_${m}`);
	
			if (aliceChange < 0) {
				aliceChange = 0;
				bobReceive = 0;
				alic.style.display = "none";
				warn.style.display = "block";
			} else {
				alic.style.display = "block";
				warn.style.display = "none";
			}
	
			// Render Alice's new UTXOs
			const aliceDiv = document.getElementById(`aliceNewList_${m}`);
			aliceDiv.innerHTML = `
				<div>Change UTXO: ${aliceChange}</div>
				
			`;
	
			// Render Bob's new UTXOs
			const bobDiv = document.getElementById(`bobNewList_${m}`);
			bobDiv.innerHTML = `
				<div>Receive UTXO: ${bobReceive}</div>
			`;
		}
	
		highlightMatchingLastDigits();
	}


    function highlightMatchingLastDigits() {
        document.querySelectorAll('.highlight').forEach(el => el.classList.remove('highlight'));
        
        const cells = document.querySelectorAll('.new-utxos strong');
        const digitMap = {};

        cells.forEach(cell => {
            const num = parseInt(cell.textContent) || 0;
            const digit = num % 10;
            if (!digitMap[digit]) digitMap[digit] = [];
            digitMap[digit].push(cell);
        });

        Object.values(digitMap).forEach(group => {
            if (group.length > 1) {
                group.forEach(cell => cell.classList.add('highlight'));
            }
        });
    }

    window.onload = function() {
        generateBobFixedUTXOs();
        createMiners();
        calculateAll();

        // Live updates
        document.addEventListener('input', (e) => {
            if (e.target.classList.contains('utxo-check') || e.target.id === 'aliceRaw') {
                calculateAll();
            }
        });
    };

    function toggleDarkMode() {
        document.body.classList.toggle('dark-mode');
    }
</script>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>