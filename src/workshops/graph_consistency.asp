<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DAG Consistency with Parallel Graphs</title>
    <meta name="description" content="DAG Consistency with Parallel Graphs">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body { transition: background-color 0.1s, color 0.1s; }
        .dagTable {
            font-family: 'Courier New', monospace;
            border-collapse: collapse;
            margin: 20px auto;
            width: 100%;
            max-width: 850px;
        }
        .dagTable th, .dagTable td {
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
        input {
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
			transition: background-color 0.2s; /* optional nice touch */
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
        .graph-header { background-color: #333; color: white; }
    </style>

</head>
<body class="dark-mode">

    <header>
        <h1>DAG Consistency with Parallel Graphs</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/graph_consistency.asp">DAG Consistency with Parallel Graphs</a>
    </section>

    <main>
        <section class="content-box">
            <h2>Transactions in a DAG Network</h2>
            <p>Each transaction contains (FEE, SND, RCV). Change any value to observe consistency across the DAG. 
            Graphs with matching rightmost decimal digits are highlighted in green.</p>
        </section>

        <!-- Graph Genesis -->
        <table border="1" class="dagTable">
            <tr>
                <th>Graph Genesis</th>
                <th>Initial Vector</th>
            </tr>
            <tr>
                <td>RCV</td>
                <td>
                    <div class="input-container">
                        <input id="genesisIV" value="0000000" maxlength="7">
                        <button class="control-btn" onclick="increment('genesisIV')">+</button>
                        <button class="control-btn" onclick="decrement('genesisIV')">-</button>
                        <span id="genesisDecimal" style="margin-left:12px; font-weight:bold;">(0)</span>
                    </div>
                </td>
            </tr>
        </table>

        <div id="graphsContainer"></div>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this consistency topic for <strong>Deep Inside</strong> workshop series.</p>
        </section>

    </main>

<script>
    const NUM_GRAPHS = 3;

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
        
        calculateAll(id);   // Pass the ID instead of cell
    }

    function decrement(id) {
        const input = document.getElementById(id);
        let val = binaryToDecimal(input.value);
        val = (val - 1 + 128) % 128;
        input.value = val.toString(2).padStart(7, '0');
        
        calculateAll(id);   // Pass the ID instead of cell
    }

	function highlightMatchingDigits(changedId = null) {
		// Clear all highlights
		document.querySelectorAll('.highlight').forEach(el => {
			el.classList.remove('highlight');
		});
	
		if (!changedId) {
			highlightAllMatchingGroups();
			return;
		}
	
		let targetDigit;
		let startGraphIndex = 1;
	
		if (changedId === 'genesisIV') {
			const genesisVal = binaryToDecimal(document.getElementById('genesisIV').value);
			targetDigit = genesisVal % 10;
			startGraphIndex = 1;
		} else {
			// Extract graph number from id (g2_rcv → 2)
			const match = changedId.match(/g(\d+)_/);
			if (match) startGraphIndex = parseInt(match[1]);
	
			const valueCell = document.getElementById('val_' + changedId);
			if (!valueCell) return;
			const num = parseInt(valueCell.textContent) || 0;
			targetDigit = num % 10;
		}
	
		// Find matching cells ONLY from the changed row and AFTER (no Genesis for downstream changes)
		const valueCells = document.querySelectorAll('.value-cell');
		const matches = [];
	
		valueCells.forEach(cell => {
			const cellId = cell.id;
			const cellMatch = cellId.match(/val_g(\d+)_/);
			if (!cellMatch) return;
	
			const graphNum = parseInt(cellMatch[1]);
	
			if (graphNum >= startGraphIndex) {
				const cellNum = parseInt(cell.textContent) || 0;
				if (cellNum % 10 === targetDigit) {
					matches.push(cell);
				}
			}
		});
	
		// === Genesis highlighting ONLY when Genesis itself was changed ===
		if (changedId === 'genesisIV') {
			const genesisDecimal = document.getElementById('genesisDecimal');
			const genesisNum = binaryToDecimal(document.getElementById('genesisIV').value);
			
			if (genesisNum % 10 === targetDigit) {   // always true in this case
				genesisDecimal.style.backgroundColor = '#90ee90';
				genesisDecimal.style.color = 'black';
				genesisDecimal.style.fontWeight = 'bold';
	
				setTimeout(() => {
					genesisDecimal.style.backgroundColor = '';
					genesisDecimal.style.color = '';
					genesisDecimal.style.fontWeight = '';
				}, 2500);
			}
		}
	
		// Highlight the downstream value cells
		if (matches.length > 1) {
			matches.forEach(cell => {
				cell.classList.remove('highlight');
				
				requestAnimationFrame(() => {
					requestAnimationFrame(() => {
						cell.classList.add('highlight');
						
						cell.addEventListener('animationend', () => {
							cell.classList.remove('highlight');
						}, { once: true });
					});
				});
			});
		}
	}

    function highlightAllMatchingGroups() {
        // Same as before - for initial load
        const valueCells = document.querySelectorAll('.value-cell');
        const digitMap = {};

        valueCells.forEach(cell => {
            const num = parseInt(cell.textContent) || 0;
            const lastDigit = num % 10;
            if (!digitMap[lastDigit]) digitMap[lastDigit] = [];
            digitMap[lastDigit].push(cell);
        });

        Object.keys(digitMap).forEach(digit => {
            if (digitMap[digit].length > 1) {
                digitMap[digit].forEach(cell => {
                    cell.classList.remove('highlight');
                    requestAnimationFrame(() => {
                        requestAnimationFrame(() => {
                            cell.classList.add('highlight');
                            cell.addEventListener('animationend', () => {
                                cell.classList.remove('highlight');
                            }, { once: true });
                        });
                    });
                });
            }
        });
    }

    function calculateAll(changedId = null) {
        // Update Genesis display
        const genesisInput = document.getElementById('genesisIV');
        const genesisVal = genesisInput.value.padStart(7, '0');
        document.getElementById('genesisDecimal').textContent = `(${binaryToDecimal(genesisVal)})`;

        // Update all graph decimal values
        for (let i = 1; i <= NUM_GRAPHS; i++) {
            ['fee','snd','rcv'].forEach(role => {
                const input = document.getElementById(`g${i}_${role}`);
                if (input) {
                    const dec = binaryToDecimal(input.value);
                    const cell = document.getElementById(`val_g${i}_${role}`);
                    if (cell) cell.textContent = dec;
                }
            });
        }

        highlightMatchingDigits(changedId);
    }

    function createGraphs() {
        const container = document.getElementById('graphsContainer');
        container.innerHTML = '';

        for (let i = 1; i <= NUM_GRAPHS; i++) {
            const table = document.createElement('table');
            table.border = "1";
            table.className = "dagTable";
            table.innerHTML = `
                <tr>
                    <td><strong>Transaction ${i}</strong></td>
                    <td><strong>Ledger Value</strong></td>
                    <td><strong>Affected Value</strong></td>
                </tr>
            `;

            const roles = [{name:"FEE",id:"fee"}, {name:"SND",id:"snd"}, {name:"RCV",id:"rcv"}];

            roles.forEach(role => {
                const row = document.createElement('tr');
                const inputId = `g${i}_${role.id}`;
                row.innerHTML = `
                    <td>${role.name}</td>
                    <td>
                        <div class="input-container">
                            <input id="${inputId}" value="${randomBinary()}" maxlength="7">
                            <button class="control-btn" onclick="increment('${inputId}')">+</button>
                            <button class="control-btn" onclick="decrement('${inputId}')">-</button>
                        </div>
                    </td>
                    <td class="value-cell" id="val_${inputId}">0</td>
                `;
                table.appendChild(row);
            });

            container.appendChild(table);
        }
    }

    window.onload = function() {
        createGraphs();
        document.getElementById('genesisIV').value = randomBinary();
        calculateAll();                    // initial load (no cell → shows all groups)
    
		document.addEventListener('input', (e) => {
			if (e.target.tagName === 'INPUT' && e.target.id.startsWith('g')) {
				const inputId = e.target.id;
				calculateAll(inputId);        // ← Pass ID, not cell
			}
		});
    };
	
    function toggleDarkMode() {
        document.body.classList.toggle('dark-mode');
    }
</script>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>