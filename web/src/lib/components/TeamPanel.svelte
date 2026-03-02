<script lang="ts">
  import { UserPlus, LogOut, Trash2 } from '@lucide/svelte';
  import type { TeamMember } from '$lib/types/contracts';

  interface Props {
    team: TeamMember[];
    isLeader: boolean;
  }

  let { team, isLeader }: Props = $props();
</script>

<div class="w-56 flex flex-col gap-3 shrink-0">
  <div class="panel flex flex-col">
    <!-- Header -->
    <div class="px-3 py-2.5 border-b border-border">
      <span class="text-xs font-medium tracking-widest text-muted-foreground uppercase">
        Team ({team.length}/4)
      </span>
    </div>

    <!-- Members -->
    {#each team as member (member.name)}
      <div class="panel-row">
        <!-- Avatar -->
        <div class="w-7 h-7 rounded-full bg-secondary border border-border flex items-center justify-center shrink-0">
          <span class="text-[10px] font-semibold text-muted-foreground uppercase">
            {member.name.charAt(0)}
          </span>
        </div>

        <!-- Info -->
        <div class="flex-1 min-w-0">
          <p class="text-sm font-medium text-foreground truncate leading-tight">{member.name}</p>
          <p class="text-[10px] tracking-wider text-muted-foreground uppercase">
            {member.leader ? 'Leader' : 'Member'}
          </p>
        </div>

        <!-- Status dot -->
        <div class="w-1.5 h-1.5 rounded-full bg-status-online shrink-0"></div>
      </div>
    {/each}
  </div>

  <!-- Actions -->
  <div class="flex flex-col gap-2">
    <button class="btn-neutral w-full flex items-center justify-center gap-2">
      <UserPlus size={13} />
      Invite
    </button>
    {#if isLeader}
      <button class="btn-outline-danger w-full flex items-center justify-center gap-2">
        <Trash2 size={13} />
        Disband
      </button>
    {:else}
      <button class="btn-outline-danger w-full flex items-center justify-center gap-2">
        <LogOut size={13} />
        Leave
      </button>
    {/if}
  </div>
</div>
