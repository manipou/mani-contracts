<script lang="ts">
	import VisibilityProvider from "$lib/providers/VisibilityProvider.svelte";
	import TopBar from "$lib/components/TopBar.svelte";
	import TeamPanel from "$lib/components/TeamPanel.svelte";
	import ContractCard from "$lib/components/ContractCard.svelte";
	import ContractDetail from "$lib/components/ContractDetail.svelte";
	import InviteNotify from "$lib/components/InviteNotify.svelte";
	import type { Contract, TeamMember, Config } from "$lib/types/contracts";

	import { visibilityStore as Visible } from "$lib/stores/VisibilityStore";
	import { useNuiEvent } from "$lib/utils/useNuiEvent";
	import { fetchNui } from "$lib/utils/fetchNui";

	let inTeam = $state(false);
	let isLeader = $state(false);
	let contracts: Contract[] = $state<Contract[]>([]);
	let team: TeamMember[] = $state<TeamMember[]>([]);

	let playerXP = $state(0);
	let playerLevel =  $state(1);
	let nextLevelXP =  $state(0);

	interface MenuData {
		TeamsData: {
			InTeam: boolean;
			IsLeader: boolean;
			Members: TeamMember[];
		};
		Contracts: Contract[];
		Level: {
			XP: number;
			Stage: number;
			Next: number;
		};
	}

	useNuiEvent<MenuData>("OpenContracts", (Data) => {
		Visible.show();
		contracts = Data.Contracts;
		inTeam = Data.TeamsData.InTeam;

		playerXP = Data.Level.XP;
		playerLevel = Data.Level.Stage;
		nextLevelXP = Data.Level.Next;

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
				onClose={() => {
					Visible.hide();
					fetchNui('HideUi');
				}}
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
						{#if sorted.filter(c => !c.Removed).length === 0}
							<div class="flex flex-col items-center justify-center h-full gap-3 text-muted-foreground select-none">
								<svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 opacity-30" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
									<path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-3-3v6M4.5 12a7.5 7.5 0 1115 0 7.5 7.5 0 01-15 0z" />
								</svg>
								<p class="text-sm font-medium tracking-wide">No contracts available</p>
								<p class="text-xs opacity-60">Check back later — new contracts will appear over time.</p>
							</div>
						{:else}
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
						{/if}
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

