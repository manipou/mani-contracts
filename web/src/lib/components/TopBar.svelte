<script lang="ts">
  import { X } from '@lucide/svelte';

  interface Props {
    xp: number;
    nextLevelXP: number;
    level: number;
    totalCount: number;
    onClose: () => void;
  }

  let { xp, nextLevelXP, level, totalCount, onClose }: Props = $props();

  const progress = $derived((xp / nextLevelXP) * 100);
</script>

<div class="flex items-center justify-between px-5 py-3 border-b border-border bg-card">
  <!-- Logo -->
  <div class="flex items-center gap-4 min-w-[200px]">
    <span class="text-sm font-semibold tracking-widest text-text-bright uppercase">
      contracts
    </span>
  </div>

  <!-- XP Bar -->
  <div class="flex-1 max-w-sm mx-6">
    <div class="flex items-center justify-between mb-1">
    <span class="text-[11px] text-muted-foreground tracking-wide">Progress</span>
      <span class="text-[11px] font-medium text-foreground tabular-nums">
        {xp.toLocaleString()} / {nextLevelXP.toLocaleString()} XP
      </span>
    </div>
    <div class="h-1.5 rounded-sm overflow-hidden" style="background: hsl(220 6% 20%);">
      <div
        class="h-full rounded-sm transition-[width] duration-500 ease-out"
        style="width: {progress}%; background: hsl(213, 42%, 50%);"
      ></div>
    </div>
  </div>

  <!-- Level & Close -->
  <div class="flex items-center gap-4 min-w-[120px] justify-end">
    <span class="text-sm font-medium text-foreground tracking-wide">
      Level {level}
    </span>
    <button
      onclick={onClose}
      class="p-1.5 rounded hover:bg-secondary hover:scale-110 transition-all duration-150"
    >
      <X size={16} class="text-muted-foreground" />
    </button>
  </div>
</div>
