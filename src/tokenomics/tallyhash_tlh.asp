<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyHash (TLH) Tokenomics</title>
    <meta name="description" content="TallyHash (TLH) Tokenomics, including wallet growth, vesting schedules, and risk assessments">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyHash (TLH) Tokenomics</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
		Tokenomics /
        <a href="tallyhash_tlh.asp">TallyHash (TLH) Tokenomics</a>
    </section>

	<br>
	
    <!-- AI-Friendly Notice -->
	<section class="yellow-box">
		<p><strong>Note:</strong> This tokenomic is structured to be <strong>AI-Friendly</strong>. An AI can access estimations and analyze them based on the content of this URL, thanks to its clear steps, pseudo-code, and examples.</p>
		<p><strong>Last update:</strong> 2025-04-30</p>
	</section>

	<br>
	
	<!-- Disclaimer Notice -->
	<section class="red-box">
		<p><strong>Disclaimer:</strong> This tokenomics document is for informational purposes only and does not constitute financial advice, an offer, or an invitation to invest in TallyHash (TLH) or any related project. The analysis and projections presented are intended to support the development of the TallyBox platform and are subject to change. Potential users and stakeholders should conduct their own research and consult with qualified professionals before making any decisions.</p>
	</section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>TLH Tokenomics Overview</h2>
            <p>The TLH (TallyHash) tokenomics for TallyBox incentivizes user adoption, node operation, and ecosystem growth within a Directed Acyclic Graph (DAG)-based blockchain platform. <br>
			   <br>
			   With a total supply of 4,000,000,000 TLH, the tokenomics employs a three-tier vesting model: <strong>Active Quarter Wallets</strong> (≥1 on-chain sender transaction in the quarter), <strong>Active Basic Wallets</strong> (≥1 sender transaction before the quarter), and <strong>Holder Wallets</strong> (TLH balance but no sender transactions). The following tables outline wallet growth, token allocations, vesting schedules, market cap projections, and risk assessments, aligned for consistency across milestones and rewards.</p>
            <div class="cyan-box">
                <h3>Table Descriptions</h3>
                <ul>
                    <li><strong>Table 1: TLH Tokenomics Timeline</strong> - Key milestones and phases (pre-launch to T+4y).</li>
                    <li><strong>Table 2: TLH Tokenomics Allocations</strong> - Distribution of 4B TLH across categories (e.g., Early Adopters, Ecosystem Growth).</li>
                    <li><strong>Table 3: TLH Tokenomics Projections</strong> - Estimated market cap and token value over time.</li>
                    <li><strong>Table 4 - Estimated Growth</strong> - Wallet and node growth, three-tier breakdown, and risk assessments (High/Mid/Low).</li>
                    <li><strong>Table 4 - Estimated Worst Case</strong> - Worst-case scenario with reduced adoption and higher Holder percentages.</li>
                    <li><strong>Table 5: Three-Tier Vesting Percentages and TLH Amounts</strong> - Detailed vesting schedule for airdrops and ecosystem rewards.</li>
                    <li><strong>Table 5 - Simplified</strong> - Condensed vesting table focusing on per-wallet TLH amounts.</li>
                </ul>
            </div>
        </section>

        <!-- Table 1 -->
        <section class="content-box">
            <h2>Table 1: TLH Tokenomics Timeline</h2>
            <table>
                <tr>
                    <th>Timeline</th>
                    <th>Phase</th>
                    <th>Milestone</th>
                </tr>
                <tr>
                    <td>T=-3m (Pre-Launch)</td>
                    <td>Testing</td>
                    <td>Test DAG, onboard 36 wallets, 2M TLH airdrop</td>
                </tr>
                <tr>
                    <td>T=0 (Launch)</td>
                    <td>Mainnet Launch</td>
                    <td>1,000 wallets, 10 nodes, 200M TLH airdrop</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>Early Adoption</td>
                    <td>5,000 wallets, 25 nodes, 24.5M TLH airdrop, 45M TLH vesting</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>Growth</td>
                    <td>10,000 wallets, 50 nodes, 1M transactions, 24.5M TLH airdrop</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>Scaling</td>
                    <td>25,000 wallets, 100 nodes, 10M transactions, 24.5M TLH airdrop</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>Mass Adoption</td>
                    <td>75,000 wallets, 500 nodes, 100M transactions, 24.5M TLH airdrop</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>Global Reach</td>
                    <td>150,000 wallets, 1,000 nodes, 1B transactions, 45M TLH vesting</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Timeline spans pre-launch to T+4y, driving wallet growth, node expansion, and transaction volume. Airdrops (2M TLH at T=-3m, 200M at T=0, 24.5M Q1–Q8) and vesting (45M TLH/quarter Q1–Q16) align with Table 2 (Marketing/Community, Ecosystem Growth) and Table 5.</p>
            </div>
			<br>
            <div class="green-box">
                <p>
				<ul>
				<li><strong>Pre-Launch:</strong> Airdrop calculator - C# function. [ <a href=tallyhash_tlh_csharp_launch_pre.txt>source code</a> ] [ <a href=tallyhash_tlh_airdrop_launch_pre.txt>calculation log</a> ]</li>
				</ul>
				</p>
            </div>
        </section>

        <!-- Table 2 -->
        <section class="content-box">
            <h2>Table 2: TLH Tokenomics Allocations</h2>
            <table>
                <tr>
                    <th>Topic</th>
                    <th>Share of Total Supply</th>
                    <th>TLH Amount</th>
                </tr>
                <tr>
                    <td>Total Supply</td>
                    <td>100%</td>
                    <td>4,000,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Ecosystem Growth</td>
                    <td>50%</td>
                    <td>2,000,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Team</td>
                    <td>19.95%</td>
                    <td>798,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Private Sale</td>
                    <td>15%</td>
                    <td>600,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Marketing/Community</td>
                    <td>10%</td>
                    <td>400,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Liquidity Pools</td>
                    <td>5%</td>
                    <td>200,000,000 TLH</td>
                </tr>
                <tr>
                    <td>Early Adopters (Pre-Launch)</td>
                    <td>0.05%</td>
                    <td>2,000,000 TLH</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Total 4B TLH supply. Marketing/Community includes 2M TLH at T=-3m, 200M TLH at T=0, and 196M TLH over Q1–Q8 (24.5M/quarter). Ecosystem Growth allocates 45M TLH/quarter Q1–Q16 (4.5M nodes, 40.5M wallets, 720M TLH total). Team and Private Sale have 2-year and 1-year cliffs, respectively. Liquidity Pools support DEX/CEX trading.</p>
            </div>
        </section>

        <!-- Table 3 -->
        <section class="content-box">
            <h2>Table 3: TLH Tokenomics Projections</h2>
            <table>
                <tr>
                    <th>Timeline</th>
                    <th>Est. Market Cap</th>
                    <th>Est. Token Value</th>
                </tr>
                <tr>
                    <td>T=0</td>
                    <td>$5M–$10M</td>
                    <td>$0.005–$0.01</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>$10M–$20M</td>
                    <td>$0.01–$0.02</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>$20M–$40M</td>
                    <td>$0.02–$0.04</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>$40M–$80M</td>
                    <td>$0.04–$0.08</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>$100M–$200M</td>
                    <td>$0.05–$0.10</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>$500M–$1B</td>
                    <td>$0.10–$0.20</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Projections assume wallet growth (Table 4) and transaction volume drive demand. Market cap based on circulating supply.</p>
            </div>
        </section>

        <!-- Table 4 - Estimated Growth -->
        <section class="content-box">
            <h2>Table 4 - Estimated Growth</h2>
            <table>
                <tr>
                    <th>Timeline</th>
                    <th>Est. Active Wallets</th>
                    <th>Estimated Node Counts</th>
                    <th>Estimated Active Quarter Wallets</th>
                    <th>Estimated Active Basic Wallets</th>
                    <th>Estimated Holder Wallets</th>
                    <th>Wallet Growth Rate</th>
                    <th>High Risk</th>
                    <th>Mid Risk</th>
                    <th>Low Risk</th>
                </tr>
                <tr>
                    <td>T=-3m (Pre-Launch)</td>
                    <td>36</td>
                    <td>0</td>
                    <td>29 (80%)</td>
                    <td>4 (10%)</td>
                    <td>3 (10%)</td>
                    <td>Initial 36 adopters</td>
                    <td>Technical bugs in DAG testing, low tester adoption</td>
                    <td>-</td>
                    <td>Slow user onboarding, UI/UX issues</td>
                </tr>
                <tr>
                    <td>T=0 (Launch)</td>
                    <td>1,000</td>
                    <td>10</td>
                    <td>500 (50%)</td>
                    <td>300 (30%)</td>
                    <td>200 (20%)</td>
                    <td>+964 (marketing, IDO)</td>
                    <td>Low marketing reach, poor IDO participation</td>
                    <td>User retention post-launch</td>
                    <td>Platform UX glitches</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>5,000</td>
                    <td>25</td>
                    <td>2,500 (50%)</td>
                    <td>1,500 (30%)</td>
                    <td>1,000 (20%)</td>
                    <td>+4,000 (social campaigns)</td>
                    <td>Low engagement from social campaigns</td>
                    <td>High transaction costs deter activity</td>
                    <td>Node stability issues</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>10,000</td>
                    <td>50</td>
                    <td>6,000 (60%)</td>
                    <td>2,500 (25%)</td>
                    <td>1,500 (15%)</td>
                    <td>+5,000 (node partnerships)</td>
                    <td>-</td>
                    <td>Delays in node partnerships, regulatory hurdles</td>
                    <td>User churn, minor platform bugs</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>25,000</td>
                    <td>100</td>
                    <td>17,500 (70%)</td>
                    <td>5,000 (20%)</td>
                    <td>2,500 (10%)</td>
                    <td>+15,000 (platform utility)</td>
                    <td>-</td>
                    <td>Slow adoption of platform utility (e.g., voting)</td>
                    <td>Scalability concerns, emerging competition</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>75,000</td>
                    <td>500</td>
                    <td>60,000 (80%)</td>
                    <td>11,250 (15%)</td>
                    <td>3,750 (5%)</td>
                    <td>+50,000 (mass adoption)</td>
                    <td>-</td>
                    <td>Competition from other blockchain platforms</td>
                    <td>Node scalability limits, user retention challenges</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>150,000</td>
                    <td>1,000</td>
                    <td>135,000 (90%)</td>
                    <td>15,000 (10%)</td>
                    <td>0 (0%)</td>
                    <td>+75,000 (global reach)</td>
                    <td>-</td>
                    <td>-</td>
                    <td>Regulatory changes, platform maturity risks</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Wallet growth scales with nodes (e.g., 500 nodes for 75,000 wallets by T+2y). Three-tier model incentivizes Active Quarter via Table 5 caps. Risks decrease over time as platform matures.</p>
            </div>
        </section>

        <!-- Table 4 - Estimated Worst Case -->
        <section class="content-box">
            <h2>Table 4 - Estimated Worst Case</h2>
            <table>
                <tr>
                    <th>Timeline</th>
                    <th>Est. Active Wallets</th>
                    <th>Estimated Node Counts</th>
                    <th>Estimated Active Quarter Wallets</th>
                    <th>Estimated Active Basic Wallets</th>
                    <th>Estimated Holder Wallets</th>
                    <th>Wallet Growth Rate</th>
                    <th>Causes</th>
                </tr>
                <tr>
                    <td>T=-3m (Pre-Launch)</td>
                    <td>20</td>
                    <td>0</td>
                    <td>10 (50%)</td>
                    <td>2 (10%)</td>
                    <td>8 (40%)</td>
                    <td>Initial 20 adopters</td>
                    <td>Technical bugs, low tester interest</td>
                </tr>
                <tr>
                    <td>T=0 (Launch)</td>
                    <td>500</td>
                    <td>5</td>
                    <td>150 (30%)</td>
                    <td>100 (20%)</td>
                    <td>250 (50%)</td>
                    <td>+480 (weak marketing)</td>
                    <td>Poor marketing, user distrust</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>2,000</td>
                    <td>10</td>
                    <td>600 (30%)</td>
                    <td>400 (20%)</td>
                    <td>1,000 (50%)</td>
                    <td>+1,500 (low engagement)</td>
                    <td>Failed campaigns, high transaction costs</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>4,000</td>
                    <td>20</td>
                    <td>1,600 (40%)</td>
                    <td>800 (20%)</td>
                    <td>1,600 (40%)</td>
                    <td>+2,000 (delayed partnerships)</td>
                    <td>Regulatory blocks, partner dropouts</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>10,000</td>
                    <td>50</td>
                    <td>5,000 (50%)</td>
                    <td>2,000 (20%)</td>
                    <td>3,000 (30%)</td>
                    <td>+6,000 (limited utility)</td>
                    <td>Slow adoption, platform bugs</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>30,000</td>
                    <td>200</td>
                    <td>18,000 (60%)</td>
                    <td>6,000 (20%)</td>
                    <td>6,000 (20%)</td>
                    <td>+20,000 (stagnant adoption)</td>
                    <td>Market competition, economic downturn</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>50,000</td>
                    <td>400</td>
                    <td>35,000 (70%)</td>
                    <td>10,000 (20%)</td>
                    <td>5,000 (10%)</td>
                    <td>+20,000 (no global reach)</td>
                    <td>Regulatory bans, scalability failures</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Worst-case scenario with reduced wallets (e.g., 30,000 vs. 75,000 at T+2y) and higher Holders (20% vs. 5%) due to low engagement. Causes include technical and market challenges.</p>
            </div>
        </section>

        <!-- Table 5 -->
        <section class="content-box">
            <h2>Table 5: Three-Tier Vesting Percentages and TLH Amounts</h2>
            <table>
                <tr>
                    <th>Quarter</th>
                    <th>Category</th>
                    <th>Marketing/Community Airdrop (TLH)</th>
                    <th>Ecosystem Growth (TLH)</th>
                    <th>Wallet/Node Count per Tier</th>
                    <th>Capped Per-Wallet TLH (Airdrop)</th>
                    <th>Capped Per-Wallet TLH (Ecosystem)</th>
                    <th>Overall Per-Wallet TLH</th>
                </tr>
                <tr>
                    <td>T=-3m</td>
                    <td>Active Quarter</td>
                    <td>1,000,000 (50%)</td>
                    <td>0</td>
                    <td>12 (wallets)</td>
                    <td>~83,333</td>
                    <td>0</td>
                    <td>~83,333</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>600,000 (30%)</td>
                    <td>0</td>
                    <td>12 (wallets)</td>
                    <td>~50,000</td>
                    <td>0</td>
                    <td>~50,000</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>400,000 (20%)</td>
                    <td>0</td>
                    <td>12 (wallets)</td>
                    <td>~33,333</td>
                    <td>0</td>
                    <td>~33,333</td>
                </tr>
                <tr>
                    <td>T=0</td>
                    <td>Active Quarter</td>
                    <td>100,000,000 (50%)</td>
                    <td>0</td>
                    <td>333 (wallets)</td>
                    <td>~300,300</td>
                    <td>0</td>
                    <td>~300,300</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>60,000,000 (30%)</td>
                    <td>0</td>
                    <td>333 (wallets)</td>
                    <td>~180,180</td>
                    <td>0</td>
                    <td>~180,180</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>40,000,000 (20%)</td>
                    <td>0</td>
                    <td>333 (wallets)</td>
                    <td>~120,120</td>
                    <td>0</td>
                    <td>~120,120</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>Active Quarter</td>
                    <td>12,250,000 (50%)</td>
                    <td>22,500,000 (50%)</td>
                    <td>1,667 (wallets)</td>
                    <td>~7,350</td>
                    <td>~13,497</td>
                    <td>~20,847</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>7,350,000 (30%)</td>
                    <td>13,500,000 (30%)</td>
                    <td>1,667 (wallets)</td>
                    <td>~4,410</td>
                    <td>~8,098</td>
                    <td>~12,508</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>4,900,000 (20%)</td>
                    <td>9,000,000 (20%)</td>
                    <td>1,667 (wallets)</td>
                    <td>~2,940</td>
                    <td>~5,399</td>
                    <td>~8,339</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>4,500,000 (10%)</td>
                    <td>25 (nodes)</td>
                    <td>-</td>
                    <td>~180,000</td>
                    <td>~180,000</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>Active Quarter</td>
                    <td>12,250,000 (50%)</td>
                    <td>22,500,000 (50%)</td>
                    <td>3,333 (wallets)</td>
                    <td>~3,675</td>
                    <td>~6,749</td>
                    <td>~10,424</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>7,350,000 (30%)</td>
                    <td>13,500,000 (30%)</td>
                    <td>3,333 (wallets)</td>
                    <td>~2,205</td>
                    <td>~4,049</td>
                    <td>~6,254</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>4,900,000 (20%)</td>
                    <td>9,000,000 (20%)</td>
                    <td>3,333 (wallets)</td>
                    <td>~1,470</td>
                    <td>~2,699</td>
                    <td>~4,169</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>4,500,000 (10%)</td>
                    <td>50 (nodes)</td>
                    <td>-</td>
                    <td>~90,000</td>
                    <td>~90,000</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>Active Quarter</td>
                    <td>12,250,000 (50%)</td>
                    <td>22,500,000 (50%)</td>
                    <td>8,333 (wallets)</td>
                    <td>~1,470</td>
                    <td>~2,700</td>
                    <td>~4,170</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>7,350,000 (30%)</td>
                    <td>13,500,000 (30%)</td>
                    <td>8,333 (wallets)</td>
                    <td>~882</td>
                    <td>~1,620</td>
                    <td>~2,502</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>4,900,000 (20%)</td>
                    <td>9,000,000 (20%)</td>
                    <td>8,333 (wallets)</td>
                    <td>~588</td>
                    <td>~1,080</td>
                    <td>~1,668</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>4,500,000 (10%)</td>
                    <td>100 (nodes)</td>
                    <td>-</td>
                    <td>~45,000</td>
                    <td>~45,000</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>Active Quarter</td>
                    <td>12,250,000 (50%)</td>
                    <td>22,500,000 (50%)</td>
                    <td>25,000 (wallets)</td>
                    <td>~490</td>
                    <td>~900</td>
                    <td>~1,390</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>7,350,000 (30%)</td>
                    <td>13,500,000 (30%)</td>
                    <td>25,000 (wallets)</td>
                    <td>~294</td>
                    <td>~540</td>
                    <td>~834</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>4,900,000 (20%)</td>
                    <td>9,000,000 (20%)</td>
                    <td>25,000 (wallets)</td>
                    <td>~196</td>
                    <td>~360</td>
                    <td>~556</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>4,500,000 (10%)</td>
                    <td>500 (nodes)</td>
                    <td>-</td>
                    <td>~9,000</td>
                    <td>~9,000</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>Active Quarter</td>
                    <td>0</td>
                    <td>22,500,000 (50%)</td>
                    <td>50,000 (wallets)</td>
                    <td>0</td>
                    <td>~450</td>
                    <td>~450</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>0</td>
                    <td>13,500,000 (30%)</td>
                    <td>50,000 (wallets)</td>
                    <td>0</td>
                    <td>~270</td>
                    <td>~270</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>0</td>
                    <td>9,000,000 (20%)</td>
                    <td>50,000 (wallets)</td>
                    <td>0</td>
                    <td>~180</td>
                    <td>~180</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>4,500,000 (10%)</td>
                    <td>1,000 (nodes)</td>
                    <td>-</td>
                    <td>~4,500</td>
                    <td>~4,500</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> T=-3m uses 50/30/20 split (36 wallets, 12/tier caps). Actual distribution (e.g., 29 Active Quarter, 3 Holder) gives ~55,555 TLH/Active Quarter, 33,333 TLH/Holder. T=0 airdrop (200M TLH) supports 1,000 wallets. Node rewards in Ecosystem column, capped (e.g., 180,000 TLH in Q1).</p>
            </div>
        </section>

        <!-- Table 5 - Simplified -->
        <section class="content-box">
            <h2>Table 5 - Simplified</h2>
            <table>
                <tr>
                    <th>Quarter</th>
                    <th>Category</th>
                    <th>Capped Per-Wallet TLH (Airdrop)</th>
                    <th>Capped Per-Wallet TLH (Ecosystem)</th>
                    <th>Overall Per-Wallet TLH</th>
                </tr>
                <tr>
                    <td>T=-3m</td>
                    <td>Active Quarter</td>
                    <td>~83,333</td>
                    <td>0</td>
                    <td>~83,333</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~50,000</td>
                    <td>0</td>
                    <td>~50,000</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~33,333</td>
                    <td>0</td>
                    <td>~33,333</td>
                </tr>
                <tr>
                    <td>T=0</td>
                    <td>Active Quarter</td>
                    <td>~300,300</td>
                    <td>0</td>
                    <td>~300,300</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~180,180</td>
                    <td>0</td>
                    <td>~180,180</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~120,120</td>
                    <td>0</td>
                    <td>~120,120</td>
                </tr>
                <tr>
                    <td>T+3m (Q1)</td>
                    <td>Active Quarter</td>
                    <td>~7,350</td>
                    <td>~13,497</td>
                    <td>~20,847</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~4,410</td>
                    <td>~8,098</td>
                    <td>~12,508</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~2,940</td>
                    <td>~5,399</td>
                    <td>~8,339</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>~180,000</td>
                    <td>~180,000</td>
                </tr>
                <tr>
                    <td>T+6m (Q2)</td>
                    <td>Active Quarter</td>
                    <td>~3,675</td>
                    <td>~6,749</td>
                    <td>~10,424</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~2,205</td>
                    <td>~4,049</td>
                    <td>~6,254</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~1,470</td>
                    <td>~2,699</td>
                    <td>~4,169</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>~90,000</td>
                    <td>~90,000</td>
                </tr>
                <tr>
                    <td>T+1y (Q4)</td>
                    <td>Active Quarter</td>
                    <td>~1,470</td>
                    <td>~2,700</td>
                    <td>~4,170</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~882</td>
                    <td>~1,620</td>
                    <td>~2,502</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~588</td>
                    <td>~1,080</td>
                    <td>~1,668</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>~45,000</td>
                    <td>~45,000</td>
                </tr>
                <tr>
                    <td>T+2y (Q8)</td>
                    <td>Active Quarter</td>
                    <td>~490</td>
                    <td>~900</td>
                    <td>~1,390</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>~294</td>
                    <td>~540</td>
                    <td>~834</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>~196</td>
                    <td>~360</td>
                    <td>~556</td>

                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>~9,000</td>
                    <td>~9,000</td>
                </tr>
                <tr>
                    <td>T+4y (Q16)</td>
                    <td>Active Quarter</td>
                    <td>0</td>
                    <td>~450</td>
                    <td>~450</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Active Basic</td>
                    <td>0</td>
                    <td>~270</td>
                    <td>~270</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Holder</td>
                    <td>0</td>
                    <td>~180</td>
                    <td>~180</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Nodes</td>
                    <td>-</td>
                    <td>~4,500</td>
                    <td>~4,500</td>
                </tr>
            </table>
            <div class="gray-box">
                <p><strong>Notes:</strong> Simplified view of Table 5, focusing on per-wallet TLH. Caps ensure fairness (e.g., 33,333 TLH for Holder at T=-3m). Values at $0.01 (Q1 Active Quarter: ~$208.47) to $0.05 (Q8 Active Quarter: ~$69.50).</p>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>