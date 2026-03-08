<script lang="ts">
	import VisibilityProvider from "$lib/providers/VisibilityProvider.svelte";
	import TopBar from "$lib/components/TopBar.svelte";
	import TeamPanel from "$lib/components/TeamPanel.svelte";
	import ContractCard from "$lib/components/ContractCard.svelte";
	import ContractDetail from "$lib/components/ContractDetail.svelte";
	import InviteNotify from "$lib/components/InviteNotify.svelte";
	import type { Contract, TeamMember } from "$lib/types/contracts";

	import { visibilityStore as Visible } from "$lib/stores/VisibilityStore";
	import { useNuiEvent } from "$lib/utils/useNuiEvent";

	let inTeam = $state(false);
	let isLeader = $state(false);
	let contracts: Contract[] = $state<Contract[]>([]);
	let team: TeamMember[] = $state<TeamMember[]>([]);

	interface MenuData {
		TeamsData: {
			InTeam: boolean;
			IsLeader: boolean;
			Members: TeamMember[];
		};
		Contracts: Contract[];
	}

	useNuiEvent<MenuData>("OpenContracts", (Data) => {
		Visible.show();
		contracts = Data.Contracts;
		inTeam = Data.TeamsData.InTeam;

		if (inTeam) {
			team = Data.TeamsData.Members;
			isLeader = Data.TeamsData.IsLeader;
		}
	});

	useNuiEvent<Contract[]>("UpdateContracts", (NewContracts) => {
		contracts = NewContracts;
	});

	type SortOption = 'xp' | 'difficulty';

	const diffOrder: Record<string, number> = { Easy: 0, Medium: 1, Hard: 2, Extreme: 3 };

	const playerXP = 1250;
	const playerLevel = 3;
	const nextLevelXP = 2000;

	let selectedContract = $state<Contract | null>(null);
	let sort = $state<SortOption>('xp');

	const sorted = $derived(
		[...contracts].sort((a, b) =>
			sort === 'xp'
				? a.requiredLevel - b.requiredLevel
				: diffOrder[a.Difficulty] - diffOrder[b.Difficulty]
		)
	);
</script>

<InviteNotify />

<VisibilityProvider>
	<div class="w-full h-screen flex items-center justify-center">
		<div class="w-full max-w-7xl max-h-[720px] h-full flex flex-col bg-background overflow-hidden noise-overlay">
			<TopBar
				xp={playerXP}
				nextLevelXP={nextLevelXP}
				level={playerLevel}
				totalCount={contracts.length}
				onClose={() => {}}
			/>

			<div class="flex flex-1 overflow-hidden p-4 gap-4">
				<!-- Team Panel (left) -->
				<TeamPanel {team} {isLeader} {inTeam} />

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
							{#each sorted as contract (contract.Id)}
								{#if !contract.Removed}
									<ContractCard
										{contract}
										{playerXP}
										onClick={() => selectedContract = contract}
									/>
								{/if}
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

