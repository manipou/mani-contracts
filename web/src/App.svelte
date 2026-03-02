<script lang="ts">
	import VisibilityProvider from "$lib/providers/VisibilityProvider.svelte";
	import TopBar from "$lib/components/TopBar.svelte";
	import TeamPanel from "$lib/components/TeamPanel.svelte";
	import ContractCard from "$lib/components/ContractCard.svelte";
	import ContractDetail from "$lib/components/ContractDetail.svelte";
	import type { Contract, TeamMember } from "$lib/types/contracts";

	type SortOption = 'xp' | 'difficulty';

	const diffOrder: Record<string, number> = { Easy: 0, Medium: 1, Hard: 2, Extreme: 3 };

	// --- Mock data ---
	const contracts: Contract[] = [
		{
			id: 'humane-heist',
			label: 'Humane Labs Raid',
			description: 'Infiltrate the Humane Labs facility and extract classified bioweapon research data. Requires stealth and coordination.',
			image: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=600&h=300&fit=crop&sat=-80',
			payout: '$125,000',
			difficulty: 'Hard',
			requiredXP: 500,
			requiredLevel: 2,
			single: false,
			active: true,
		},
		{
			id: 'vault-breach',
			label: 'Pacific Standard Vault',
			description: 'Break into the Pacific Standard vault using thermal charges. Disable the security grid and extract within 8 minutes.',
			image: 'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=600&h=300&fit=crop&sat=-80',
			payout: '$250,000',
			difficulty: 'Extreme',
			requiredXP: 1500,
			requiredLevel: 5,
			single: false,
			active: false,
		},
		{
			id: 'cargo-intercept',
			label: 'Cargo Ship Intercept',
			description: 'Board the cargo vessel at Terminal 4 and secure the weapons shipment before it reaches international waters.',
			image: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=600&h=300&fit=crop&sat=-60',
			payout: '$95,000',
			difficulty: 'Medium',
			requiredXP: 800,
			requiredLevel: 3,
			single: false,
			active: false,
		},
		{
			id: 'meth-lab',
			label: 'Underground Lab Setup',
			description: 'Establish a new underground production facility. Secure the location, install equipment, and eliminate competition.',
			image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=300&fit=crop&hue-rotate=270&sat=-20',
			payout: '$65,000',
			difficulty: 'Easy',
			requiredXP: 300,
			requiredLevel: 1,
			single: true,
			active: false,
		},
		{
			id: 'convoy-ambush',
			label: 'Military Convoy Ambush',
			description: 'Intercept the military convoy transporting prototype weapons tech. Heavy resistance expected.',
			image: 'https://images.unsplash.com/photo-1486325212027-8081e485255e?w=600&h=300&fit=crop&sat=-80',
			payout: '$350,000',
			difficulty: 'Extreme',
			requiredXP: 2500,
			requiredLevel: 7,
			single: false,
			active: false,
		},
		{
			id: 'jewelry-heist',
			label: 'Vangelico Jewelry Store',
			description: 'Smash and grab at the Vangelico jewelry store. Get in, fill the bags, get out before the cops arrive.',
			image: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&h=300&fit=crop&sat=-40',
			payout: '$45,000',
			difficulty: 'Easy',
			requiredXP: 200,
			requiredLevel: 1,
			single: true,
			active: false,
		},
		
	];

	const team: TeamMember[] = [
		{ name: 'Mani', leader: true },
		{ name: 'Ghost', leader: false },
		{ name: 'Viper', leader: false },
	];

	const playerXP = 1250;
	const playerLevel = 3;
	const nextLevelXP = 2000;

	let selectedContract = $state<Contract | null>(null);
	let sort = $state<SortOption>('xp');

	const isLeader = team.some(m => m.leader && m.name === 'Mani');
	const unlockedCount = $derived(contracts.filter(c => playerXP >= c.requiredXP).length);
	const sorted = $derived(
		[...contracts].sort((a, b) =>
			sort === 'xp'
				? a.requiredLevel - b.requiredLevel
				: diffOrder[a.difficulty] - diffOrder[b.difficulty]
		)
	);
</script>

<VisibilityProvider>
	<div class="w-full h-screen flex items-center justify-center">
		<div class="w-full max-w-7xl max-h-[720px] h-full flex flex-col bg-background overflow-hidden noise-overlay">
			<TopBar
				xp={playerXP}
				nextLevelXP={nextLevelXP}
				level={playerLevel}
				unlockedCount={unlockedCount}
				totalCount={contracts.length}
				onClose={() => {}}
			/>

			<div class="flex flex-1 overflow-hidden p-4 gap-4">
				<!-- Team Panel (left) -->
				<TeamPanel {team} {isLeader} />

				<!-- Contracts (right) -->
				<div class="flex-1 flex flex-col overflow-hidden">
					<!-- Header -->
					<div class="flex items-center justify-between mb-3">
						<h2 class="text-xs font-medium tracking-widest text-muted-foreground uppercase">
							Contracts
						</h2>
						<select
							bind:value={sort}
							class="text-[11px] bg-secondary border border-border rounded px-2 py-1 text-foreground outline-none cursor-pointer"
						>
							<option value="xp">Sort: Level Required</option>
							<option value="difficulty">Sort: Difficulty</option>
						</select>
					</div>

					<!-- Grid -->
					<div class="flex-1 overflow-y-auto pr-1">
						<div class="grid grid-cols-3 gap-3">
							{#each sorted as contract (contract.id)}
								<ContractCard
									{contract}
									{playerXP}
									onClick={() => selectedContract = contract}
								/>
							{/each}
						</div>
					</div>
				</div>
			</div>

			<!-- Detail Modal -->
			{#if selectedContract}
				<ContractDetail
					contract={selectedContract}
					{playerXP}
					onClose={() => selectedContract = null}
				/>
			{/if}
		</div>
	</div>
</VisibilityProvider>

