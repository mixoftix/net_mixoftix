<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Block Consistency</title>
    <meta name="description" content="Integrity vs. Consistency to observe how the blockchain responds to manipulation of sensitive data.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body {
            transition: background-color 0.1s, color 0.1s;
        }
        .subtitle {
            font-size: 0.9em;
            margin-top: 0;
            margin-bottom: 5px;
        }
        .merkleTable {
            font-family: 'Courier New', monospace;
            border-collapse: collapse;
            margin: 20px auto;
        }
        .merkleTable th, .merkleTable td {
            font-family: 'Courier New', monospace;
            padding: 6px;
            text-align: center;
            vertical-align: middle;
        }
        .text {
            font-size: 1em;
            line-height: 1.5;
            margin-bottom: 20px;
        }
        .input-container {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        input {
            font-family: 'Courier New', monospace;
            padding: 4px;
            width: 80px;
            margin-right: 2px;
        }
        .control-btn {
            font-family: 'Courier New', monospace;
            padding: 2px 6px;
            cursor: pointer;
            margin: 0 2px;
        }
        .genesis {
            margin-bottom: 20px;
        }
        /* Highlight class for changed cells */
        .highlight {
            animation: fadeGreen 3s ease-out forwards;
        }
        @keyframes fadeGreen {
            0% { background-color: #90ee90; } /* Light green */
            100% { background-color: transparent; }
        }
    </style>


</head>
<body class="dark-mode">
    <header>
        <h1>Block Consistency</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
		Workshops /
        <a href="/workshops/block_consistency.asp">Block Consistency</a>
    </section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>'Integrity' at a leaf, 'Consistency' across blocks.</h2>
            <p>
			Each block’s Merkle root is linked to the previous hashed root using XOR, ensuring continuity in the chain. Modify the Genesis IV or individual leaves to observe how the blockchain responds to manipulation of sensitive data.
			<br>
			</p>
        </section>

        <!-- The Merkle Tree -->
        <section class="content-box">
            <h2>Blockchain Consistency with Merkle Trees</h2>

			<!-- Block Genesis -->
			<table border="1" class="merkleTable" id="block1">
				<tr>
					<th>Block Genesis</th>
					<th>Initial Vector</th>
				</tr>
				<tr>
					<td>
						--
					</td>
					<td width="35%">
							<div class="input-container">
								<input id="genesisIV" value="0000000" placeholder="7-bit IV">
								<button class="control-btn" onclick="increment('genesisIV')">+</button>
								<button class="control-btn" onclick="decrement('genesisIV')">-</button>
							</div>
					</td>
				</tr>
			</table>

			<!-- Block 1 -->
			<table border="1" class="merkleTable" id="block1">
				<tr>
					<th>Block 1</th>
					<th>Parents</th>
					<th>Root</th>
					<th>Root XOR Previous</th>
				</tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block1_leaf1" value="0110011" placeholder="Leaf 1">
							<button class="control-btn" onclick="increment('block1_leaf1')">+</button>
							<button class="control-btn" onclick="decrement('block1_leaf1')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block1_parent5">-</td>
					<td rowspan="8" id="block1_root">-</td>
					<td rowspan="8" id="block1_hashedRoot">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block1_leaf2" value="1101001" placeholder="Leaf 2">
							<button class="control-btn" onclick="increment('block1_leaf2')">+</button>
							<button class="control-btn" onclick="decrement('block1_leaf2')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block1_leaf3" value="1011001" placeholder="Leaf 3">
							<button class="control-btn" onclick="increment('block1_leaf3')">+</button>
							<button class="control-btn" onclick="decrement('block1_leaf3')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block1_parent6">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block1_leaf4" value="0000100" placeholder="Leaf 4">
							<button class="control-btn" onclick="increment('block1_leaf4')">+</button>
							<button class="control-btn" onclick="decrement('block1_leaf4')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
			</table>
		
			<!-- Block 2 -->
			<table border="1" class="merkleTable" id="block2">
				<tr>
					<th>Block 2</th>
					<th>Parents</th>
					<th>Root</th>
					<th>Root XOR Previous</th>
				</tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block2_leaf1" value="1010101" placeholder="Leaf 1">
							<button class="control-btn" onclick="increment('block2_leaf1')">+</button>
							<button class="control-btn" onclick="decrement('block2_leaf1')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block2_parent5">-</td>
					<td rowspan="8" id="block2_root">-</td>
					<td rowspan="8" id="block2_hashedRoot">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block2_leaf2" value="0101010" placeholder="Leaf 2">
							<button class="control-btn" onclick="increment('block2_leaf2')">+</button>
							<button class="control-btn" onclick="decrement('block2_leaf2')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block2_leaf3" value="1110000" placeholder="Leaf 3">
							<button class="control-btn" onclick="increment('block2_leaf3')">+</button>
							<button class="control-btn" onclick="decrement('block2_leaf3')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block2_parent6">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block2_leaf4" value="0001111" placeholder="Leaf 4">
							<button class="control-btn" onclick="increment('block2_leaf4')">+</button>
							<button class="control-btn" onclick="decrement('block2_leaf4')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
			</table>
		
			<!-- Block 3 -->
			<table border="1" class="merkleTable" id="block3">
				<tr>
					<th>Block 3</th>
					<th>Parents</th>
					<th>Root</th>
					<th>Root XOR Previous</th>
				</tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block3_leaf1" value="0011001" placeholder="Leaf 1">
							<button class="control-btn" onclick="increment('block3_leaf1')">+</button>
							<button class="control-btn" onclick="decrement('block3_leaf1')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block3_parent5">-</td>
					<td rowspan="8" id="block3_root">-</td>
					<td rowspan="8" id="block3_hashedRoot">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block3_leaf2" value="1100110" placeholder="Leaf 2">
							<button class="control-btn" onclick="increment('block3_leaf2')">+</button>
							<button class="control-btn" onclick="decrement('block3_leaf2')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block3_leaf3" value="1001001" placeholder="Leaf 3">
							<button class="control-btn" onclick="increment('block3_leaf3')">+</button>
							<button class="control-btn" onclick="decrement('block3_leaf3')">-</button>
						</div>
					</td>
					<td rowspan="4" id="block3_parent6">-</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<div class="input-container">
							<input id="block3_leaf4" value="0110110" placeholder="Leaf 4">
							<button class="control-btn" onclick="increment('block3_leaf4')">+</button>
							<button class="control-btn" onclick="decrement('block3_leaf4')">-</button>
						</div>
					</td>
				</tr>
				<tr></tr>
			</table>

        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this consistency topic for <strong>Deep Inside</strong> workshop series.</p>
        </section>

    </main>

    <script>
        // Object to store previous values
        let previousValues = {
            block1: { parent5: '', parent6: '', root: '', hashedRoot: '' },
            block2: { parent5: '', parent6: '', root: '', hashedRoot: '' },
            block3: { parent5: '', parent6: '', root: '', hashedRoot: '' }
        };

        // Toggle between dark and light mode
        function toggleMode() {
            const body = document.body;
            if (document.getElementById('modeCheckbox').checked) {
                body.classList.remove('light');
                body.classList.add('dark');
            } else {
                body.classList.remove('dark');
                body.classList.add('light');
            }
        }

        // Generate random 7-bit binary value
        function randomBinary() {
            let binary = '';
            for (let i = 0; i < 7; i++) {
                binary += Math.floor(Math.random() * 2);
            }
            return binary;
        }

        // XOR two binary strings
        function xorBinary(a, b) {
            let result = '';
            for (let i = 0; i < a.length; i++) {
                result += (parseInt(a[i]) ^ parseInt(b[i])).toString();
            }
            return result;
        }

        // Convert binary to decimal
        function binaryToDecimal(binary) {
            return parseInt(binary, 2);
        }

        // Increment binary value
        function increment(id) {
            let input = document.getElementById(id);
            let value = binaryToDecimal(input.value.padStart(7, '0'));
            value = (value + 1) % 128; // Wrap at 127
            input.value = value.toString(2).padStart(7, '0');
            calculateAllMerkleTrees();
        }

        // Decrement binary value
        function decrement(id) {
            let input = document.getElementById(id);
            let value = binaryToDecimal(input.value.padStart(7, '0'));
            value = (value - 1 + 128) % 128; // Wrap below 0 to 127
            input.value = value.toString(2).padStart(7, '0');
            calculateAllMerkleTrees();
        }

        // Apply highlight to changed cells
        function highlightChange(elementId, newValue, prevValue) {
            if (newValue !== prevValue) {
                const element = document.getElementById(elementId);
                element.classList.remove('highlight'); // Reset to avoid overlap
                void element.offsetWidth; // Trigger reflow for animation restart
                element.classList.add('highlight');
            }
        }

        // Calculate a single Merkle Tree for a block
        function calculateMerkleTree(blockPrefix, prevHashedRoot) {
            const leaf1 = document.getElementById(`${blockPrefix}_leaf1`).value.padStart(7, '0');
            const leaf2 = document.getElementById(`${blockPrefix}_leaf2`).value.padStart(7, '0');
            const leaf3 = document.getElementById(`${blockPrefix}_leaf3`).value.padStart(7, '0');
            const leaf4 = document.getElementById(`${blockPrefix}_leaf4`).value.padStart(7, '0');

            // Validate inputs
            const regex = /^[01]{7}$/;
            if (!regex.test(leaf1) || !regex.test(leaf2) || !regex.test(leaf3) || !regex.test(leaf4)) {
                alert(`Invalid 7-bit binary value in ${blockPrefix}`);
                return null;
            }

            // Calculate parents
            const parent5 = xorBinary(leaf1, leaf2);
            const parent6 = xorBinary(leaf3, leaf4);
            const parent5Html = `${parent5}<br>(${binaryToDecimal(parent5)})`;
            const parent6Html = `${parent6}<br>(${binaryToDecimal(parent6)})`;
            highlightChange(`${blockPrefix}_parent5`, parent5Html, document.getElementById(`${blockPrefix}_parent5`).innerHTML);
            highlightChange(`${blockPrefix}_parent6`, parent6Html, document.getElementById(`${blockPrefix}_parent6`).innerHTML);
            document.getElementById(`${blockPrefix}_parent5`).innerHTML = parent5Html;
            document.getElementById(`${blockPrefix}_parent6`).innerHTML = parent6Html;

            // Calculate root
            const root = xorBinary(parent5, parent6);
            const rootHtml = `${root}<br>(${binaryToDecimal(root)})`;
            highlightChange(`${blockPrefix}_root`, rootHtml, document.getElementById(`${blockPrefix}_root`).innerHTML);
            document.getElementById(`${blockPrefix}_root`).innerHTML = rootHtml;

            // Calculate hashed root with previous
            const hashedRoot = xorBinary(root, prevHashedRoot);
            const hashedRootHtml = `${hashedRoot}<br>(${binaryToDecimal(hashedRoot)})`;
            highlightChange(`${blockPrefix}_hashedRoot`, hashedRootHtml, document.getElementById(`${blockPrefix}_hashedRoot`).innerHTML);
            document.getElementById(`${blockPrefix}_hashedRoot`).innerHTML = hashedRootHtml;

            // Update previous values
            previousValues[blockPrefix] = {
                parent5: parent5Html,
                parent6: parent6Html,
                root: rootHtml,
                hashedRoot: hashedRootHtml
            };

            return hashedRoot; // Return the hashed root for chaining
        }

        // Calculate all Merkle Trees in sequence
        function calculateAllMerkleTrees() {
            const genesisIV = document.getElementById('genesisIV').value.padStart(7, '0');
            if (!/^[01]{7}$/.test(genesisIV)) {
                alert('Invalid 7-bit binary value in Genesis IV');
                return;
            }

            const block1HashedRoot = calculateMerkleTree('block1', genesisIV);
            if (!block1HashedRoot) return;

            const block2HashedRoot = calculateMerkleTree('block2', block1HashedRoot);
            if (!block2HashedRoot) return;

            calculateMerkleTree('block3', block2HashedRoot);
        }

        // Set initial random values and calculate trees
        window.onload = function() {
            const blocks = ['block1', 'block2', 'block3'];
            blocks.forEach(block => {
                ['leaf1', 'leaf2', 'leaf3', 'leaf4'].forEach(leaf => {
                    document.getElementById(`${block}_${leaf}`).value = randomBinary();
                });
            });
            document.getElementById('genesisIV').value = randomBinary();
            calculateAllMerkleTrees();
        };

        // Add event listeners to inputs for typing
        document.querySelectorAll('input').forEach(input => {
            if (input.type === 'text') {
                input.addEventListener('input', calculateAllMerkleTrees);
            }
        });
    </script>

    <!-- Footer -->
    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>