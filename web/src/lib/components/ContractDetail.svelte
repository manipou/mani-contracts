<script lang="ts">
  import { X, Lock, Shield, Users, User, Package } from '@lucide/svelte';
  import type { Contract, ContractState } from '$lib/types/contracts';

  interface Props {
    contract: Contract;
    playerXP: number;
    onClose: () => void;
  }

  let { contract, playerXP, onClose }: Props = $props();

  const getState = (c: Contract, xp: number): ContractState => {
    // Todo
    // if (c.active) return 'active';
    // if (xp < c.requiredXP) return 'locked';
    return 'available';
  };

  const state = $derived(getState(contract, playerXP));
</script>

<div class="fixed inset-0 z-50 flex items-center justify-center p-8 animate-fade">
  <!-- Backdrop -->
  <!-- svelte-ignore a11y_click_events_have_key_events -->
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div class="absolute inset-0 bg-background/85" onclick={onClose}></div>

  <!-- Modal -->
  <div class="relative w-full max-w-md panel overflow-hidden animate-fade">
    <!-- Close -->
    <button
      onclick={onClose}
      class="absolute top-3 right-3 z-10 p-1.5 rounded hover:bg-secondary hover:scale-110 transition-all duration-150"
    >
      <X size={16} class="text-muted-foreground" />
    </button>

    <!-- Image -->
    <div class="relative h-44 overflow-hidden">
      <img
        src={contract.Image}
        alt={contract.Label}
        class="w-full h-full object-cover {state === 'locked' ? 'grayscale brightness-[0.35]' : 'brightness-[0.6]'}"
      />
      <div class="absolute bottom-0 left-0 right-0 h-16 bg-linear-to-t from-card to-transparent"></div>
      <div class="absolute bottom-3 left-4">
        <h2 class="text-base font-medium tracking-wide text-text-bright">
          {contract.Label}
        </h2>
      </div>
    </div>

    <!-- Content -->
    <div class="p-4 flex flex-col gap-3">
      <!-- Stats row -->
      <div class="grid grid-cols-2 gap-2">
        {#each [
          { label: 'Difficulty', value: contract.Difficulty },
          { label: 'Type', value: 'Team' },
        ] as stat, i}
          <div class="flex flex-col items-center p-2.5 rounded bg-secondary border border-border">
            {#if i === 0}
              <Shield size={14} class="text-muted-foreground mb-1" />
            {:else if contract.OneTime}
              <User size={14} class="text-muted-foreground mb-1" />
            {:else}
              <Users size={14} class="text-muted-foreground mb-1" />
            {/if}
            <span class="text-xs font-semibold text-foreground">{stat.value}</span>
            <span class="text-[10px] text-muted-foreground uppercase tracking-wide">{stat.label}</span>
          </div>
        {/each}
      </div>

      <!-- Requirements -->
      {#if contract.Requirements && contract.Requirements.length > 0}
        <div class="flex flex-col gap-1.5 p-3 rounded bg-secondary border border-border">
          <div class="flex items-center gap-1.5 mb-0.5">
            <Package size={13} class="text-muted-foreground" />
            <span class="text-[10px] text-muted-foreground uppercase tracking-wide">Requirements</span>
          </div>
          {#each contract.Requirements as req}
            <div class="flex items-center gap-2">
              <span class="w-1 h-1 rounded-full bg-muted-foreground shrink-0"></span>
              <span class="text-xs text-foreground">{req}</span>
            </div>
          {/each}
        </div>
      {/if}

      <!-- Level -->
      <div class="flex items-center justify-between px-3 py-2.5 rounded bg-secondary border border-border">
        <span class="text-[11px] text-muted-foreground uppercase tracking-wide">Required Level</span>
        <span class="text-sm font-semibold tabular-nums {playerXP >= contract.requiredXP ? 'text-status-online' : 'text-destructive'}">
          Level {contract.RequiredLevel}
        </span>
      </div>

      <!-- Divider -->
      <div class="border-t border-border"></div>

      <!-- Description -->
      <p class="text-sm text-secondary-foreground leading-relaxed">
        {contract.Description}
      </p>

      <!-- Action -->
      {#if state === 'active'}
        <div class="flex items-center justify-center gap-2 py-2.5 rounded border" style="background: hsl(213 42% 46% / 0.1); border-color: hsl(213 42% 46% / 0.3);">
          <span class="text-xs font-medium tracking-widest uppercase" style="color: hsl(213, 60%, 68%);">
            In Progress
          </span>
        </div>
      {:else if state === 'locked'}
        <button disabled class="btn-solid w-full flex items-center justify-center gap-2 py-2.5">
          <Lock size={14} />
          Locked — Requires Level {contract.RequiredLevel}
        </button>
      {:else}
        <button class="btn-solid w-full py-2.5">
          Start Contract
        </button>
      {/if}
    </div>
  </div>
</div>
