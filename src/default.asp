<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MixofTix Developers Network</title>
    <meta name="description" content="for curious minds">
    <meta name="author" content="shahiN Noursalehi">
	<!--#INCLUDE virtual="/inc_styles.asp"-->
</head>
<body class="dark-mode">
    <header>
        <h1>MixofTix Developers Network</h1>
        <p>( for curious minds )</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here:
        <a href="/">Home</a>
    </section>

    <!-- Main Content -->
    <main>

		<!-- The content -->
		<section class="content-box">
			<h2>MixofTix, for curious minds..</h2>
			<p>
			Welcome to MixofTix, a hub for innovative ideas and hands-on learning! Dive into our featured projects, Azim-Coin and TallyBox, 
			where creativity meets technology. Azim-Coin introduces you to the world of decentralized digital currency, while TallyBox 
			facilitates micro payments with a user-friendly twist. Explore our tutorials on the main page to kickstart your journey, whether
			you're a beginner or a seasoned tinkerer. 
			<br>
			<br>
			Unleash your curiosity and build something extraordinary with MixofTix!
			</p>
		</section>

        <!-- Colored Boxes -->
		<section class="content-box">
            <div class="gray-box">
                <h2>Toturials</h2>
                <h3>General</h3>
                <p>
				<a href="/tutorials/cryptography_ecdsa_rfc_6979.asp" >Cryptography, ECDSA, RFC-6979</a>
				<br>
				<a href="/tutorials/cryptography_ecdsa_raw_der.asp" >Cryptography, ECDSA, RAW to DER</a>
				<br>
				<br>
				<a href="/tutorials/cryptography_blockchain_base58.asp" >Cryptography, Blockchain, Base58</a>
				<br>
				<a href="/tutorials/cryptography_blockchain_decimals.asp" >Cryptography, Blockchain, Decimals</a>
				<br>
				</p>
                <h3>Decent TallyBox</h3>
                <p>
				<a href="/tutorials/tallybox_wallet_creation.asp" >Wallet Creation - Pseudo Edition</a>
				<br>
				<a href="/tutorials/tallybox_wallet_transaction.asp" >Wallet Transaction - Pseudo Edition</a>
				<br>
				<a href="/tutorials/tallybox_wallet_transaction_group.asp" >Wallet Groupp Transaction - Pseudo Edition</a>
				<br>
				<br>
				</p>

                <h3>Decent Graph Payment Processor</h3>
                <p>
				<a href="/tutorials/tallybox_processor_order_accept.asp" >GPP - Order Accept</a>
				<br>
				<a href="/tutorials/tallybox_processor_ods_shardening.asp" >GPP - Local Shardening</a>
				<br>
				<a href="/tutorials/tallybox_processor_buffer_archiving.asp" >GPP - Buffer Archiving</a>
				<br>
				<a href="/tutorials/tallybox_processor_database_structure.asp" >GPP - Database Structure</a>
				<br>
				<a href="/tutorials/tallybox_processor_treasury_accept.asp" >GPP - Treasury Accept</a>
				<br>
				<a href="/tutorials/tallybox_processor_p2p_network_flow.asp" >GPP - P2P Network Flow</a>
				<br>
				</p>

            </div>
			<br>
            <div class="gray-box">
                <h3>Tokenomics - TLH Coin</h3>
                <p>
				<a href="/tokenomics/tallyhash_tlh.asp" >TallyHash (TLH) Tokenomics</a>
				<br>
				</p>
            </div>
			<br>
            <div class="gray-box">
                <h3>Workshops - Deep Inside</h3>
                <p>
		        <a href="/workshops/nist_sp_800_22.asp">NIST SP 800-22 (RNG Test Suite)</a>
				<br>
		        <a href="/workshops/nist_sp_800_90b.asp">NIST SP 800-90B (Entropy Source Validation)</a>
				<br>
				<a href="/workshops/entropy_lab_decent_dice.asp" >Decent Dice (Entropy Lab)</a>
				<br>
				<a href="/workshops/entropy_lab_dice_to_prvkey.asp" >Dice to Private Key (Entropy Lab)</a>
				<br>
				<br>
				<a href="/workshops/block_consistency.asp" >Block Consistency</a>
				<br>
		        <a href="/workshops/block_consensus.asp">Block Forks and Consensus</a>
				<br>
		        <a href="/workshops/block_structure_utxo.asp">Block Structure (UTXO Model)</a>
				<br>
		        <a href="/workshops/block_structure_balance.asp">Block Structure (Balance Model)</a>
				<br>
				<br>
				<a href="/workshops/graph_consistency.asp" >Graph Consistency</a>
				<br>
				<a href="/workshops/graph_structure_balance.asp" >Graph Structure (Balance Model)</a>
				<br>
				<br>
		        <a href="/workshops/ai_lab_nn.asp">Neural Network (AI Lab)</a>
				<br>
				<a href="/workshops/ai_lab_ga.asp">Genetic Algorithm (AI Lab)</a>
				</p>
            </div>
			<br>
			<div class="cyan-box">
				<h3>Codes and Docs</h3>
				<ul>
					<li><strong>GitHub</strong>: 
<pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">
Wallet series:
   <a href="https://github.com/mixoftix/decent_tallybox_html" target="_blank" class="a_orange">decent_tallybox_html</a>
   <a href="https://github.com/mixoftix/decent_tallybox_python" target="_blank" class="a_orange">decent_tallybox_python</a>
   <a href="https://github.com/mixoftix/decent_tallybox_android" target="_blank" class="a_orange">decent_tallybox_android</a>
<br>
GPP Series:
   <a href="https://github.com/mixoftix/decent_gpp_sql" target="_blank" class="a_orange">decent_gpp_sql</a>
<br>
P2P Series:
   <a href="https://github.com/mixoftix/decent_p2p_csharp" target="_blank" class="a_orange">decent_p2p_csharp</a>
</pre>
					</li>
					<li><strong>YouTube</strong>: 
<pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">
Persian series:
   <a href="https://www.youtube.com/watch?v=Vovl1b8JrsQ" target="_blank" class="a_orange">GPP - Setup</a>
   <a href="https://www.youtube.com/watch?v=WpnHjLUUG14" target="_blank" class="a_orange">Wallet - Python</a>
   <a href="https://youtu.be/HNdsGMv5gOw" target="_blank" class="a_orange">P2P - Setup</a>
<br>
   <a href="https://youtu.be/jpZ3jsvODvk" target="_blank" class="a_orange">Block vs. Graph</a>
   <a href="https://youtu.be/2ynkRhRxQw8" target="_blank" class="a_orange">Kleptography</a>
<br>
English Series:
   <a href="https://www.youtube.com/watch?v=5Lf6BXK0U_k" target="_blank" class="a_orange">GPP - Setup</a>
</pre>
				</ul>
			</div>
            <br>
            <div class="green-box">
                <h3>Downloads and Live Demo</h3>
                <p>
				<a href="https://wallet.mixoftix.net" target="_blank">Decent TallyBox Wallet - Download</a>
				<br>
				<a href="https://wallet.mixoftix.net" target="_blank">Decent P2P Node - Download</a>
				<br>
				<a href="http://gpp_mars.mixoftix.net" target="_blank">Decent GPP Node - Live Demo</a>
				<br>
				</p>
            </div>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
