<script lang="ts">
  import { Lock, Zap } from '@lucide/svelte';
  import type { Contract, ContractState } from '$lib/types/contracts';

  interface Props {
    contract: Contract;
    playerXP: number;
    onClick: () => void;
  }

  let { contract, playerXP, onClick }: Props = $props();

  const getState = (c: Contract, xp: number): ContractState => {
    // Todo
    if (c.InProgress) return 'active';
    // if (xp < c.requiredXP) return 'locked';
    return 'available';
  };

  const diffTag: Record<string, string> = {
    Easy: 'tag-easy',
    Medium: 'tag-medium',
    Hard: 'tag-hard',
    Extreme: 'tag-extreme',
  };

  const state = $derived(getState(contract, playerXP));
</script>

<button
  onclick={onClick}
  class="relative group text-left rounded overflow-hidden border bg-card transition-colors duration-150
    {state === 'active'
      ? 'border-border border-l-[3px] border-l-primary'
      : 'border-border hover:bg-surface-hover'}
    {state === 'locked' ? 'opacity-55' : ''}"
>
  <!-- Image -->
  <div class="relative h-28 overflow-hidden">
    <img
      src={contract.Image}
      alt={contract.Label}
      class="w-full h-full object-cover transition-opacity duration-150
        {state === 'locked'
          ? 'grayscale brightness-[0.4]'
          : 'brightness-[0.65] group-hover:brightness-[0.55]'}"
    />

    <!-- Lock overlay -->
    {#if state === 'locked'}
      <div class="absolute inset-0 flex items-center justify-center">
        <Lock size={18} class="text-status-locked" />
      </div>
    {/if}

    <!-- Active label -->
    {#if state === 'active'}
      <div class="absolute top-2 right-2 px-2 py-0.5 rounded-sm" style="background: hsl(213 42% 46% / 0.85);">
        <span class="text-[10px] font-medium tracking-widest text-white uppercase flex items-center gap-1">
          <Zap size={9} /> In Progress
        </span>
      </div>
    {/if}

    <!-- One-time tag -->
    {#if contract.OneTime}
      <div class="absolute top-2 left-2 px-1.5 py-0.5 rounded-sm" style="background: hsl(220 8% 10% / 0.75);">
        <span class="text-[10px] font-medium tracking-widest text-muted-foreground uppercase">
          One-Time
        </span>
      </div>
    {/if}
  </div>

  <!-- Info -->
  <div class="p-3 pb-3.5">
    <h3 class="text-sm font-medium text-text-bright leading-tight mb-2 truncate">
      {contract.Label}
    </h3>
    <div class="flex items-center justify-between">
      <span class="text-[11px] text-muted-foreground tabular-nums">
        {state === 'locked'
          ? `Requires Level ${contract.RequiredLevel}`
          : `Level ${contract.RequiredLevel}`}
      </span>
      <span class={diffTag[contract.Difficulty]}>{contract.Difficulty}</span>
    </div>
  </div>
</button>
