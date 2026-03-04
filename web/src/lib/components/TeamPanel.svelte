<script lang="ts">
  import { UserPlus, LogOut, Trash2, Users, Send, X } from '@lucide/svelte';
  import type { TeamMember } from '$lib/types/contracts';
  import { fetchNui } from "$lib/utils/fetchNui";


  interface Props {
    team: TeamMember[];
    isLeader: boolean;
    inTeam: boolean;
  }

  let { team, isLeader, inTeam }: Props = $props();

  let showInvite = $state(false);
  let inviteId = $state('');
  let inviteInput = $state<HTMLInputElement | null>(null);

  function toggleInvite() {
    showInvite = !showInvite;
    inviteId = '';
    if (showInvite) {
      setTimeout(() => inviteInput?.focus(), 120);
    }
  }

  async function SendInvite() {
    const id = parseInt(String(inviteId));
    if (!id || id <= 0) return;
    await fetchNui('InviteTeam', { Source: id });
    showInvite = false;
    inviteId = '';
  }

  function onInviteKeydown(e: KeyboardEvent) {
    if (e.key === 'Enter') SendInvite();
    if (e.key === 'Escape') toggleInvite();
  }

  async function CreateTeam() {
    const TeamData = await fetchNui('CreateTeam');
    if (TeamData.Success) {
      team = TeamData.Data.Members;
      isLeader = true;
      inTeam = true;
    }
  }

  async function DisbandTeam() {
    const Success = await fetchNui('DisbandTeam');
    if (Success) {
      team = [];
      isLeader = false;
      inTeam = false;
    }
  }
</script>

<div class="w-56 flex flex-col gap-3 shrink-0">
  {#if !inTeam}
    <!-- No team -->
    <div class="panel flex flex-col items-center justify-center gap-3 py-8 px-4 text-center flex-1">
      <div class="w-10 h-10 rounded-full bg-secondary border border-border flex items-center justify-center">
        <Users size={18} class="text-muted-foreground" />
      </div>
      <div>
        <p class="text-sm font-medium text-foreground">No Team</p>
        <p class="text-[11px] text-muted-foreground mt-0.5">Create or join a team to run contracts together.</p>
      </div>
      <button class="btn-solid w-full flex items-center justify-center gap-2 mt-1" onclick={CreateTeam}>
        <UserPlus size={13} />
        Create Team
      </button>
    </div>
  {:else}
    <div class="panel flex flex-col">
      <!-- Header -->
      <div class="px-3 py-2.5 border-b border-border">
        <span class="text-xs font-medium tracking-widest text-muted-foreground uppercase">
          Team ({team.length}/4)
        </span>
      </div>

      <!-- Members -->
      {#each team as member (member.Name)}
        <div class="panel-row">
          <!-- Avatar -->
          <div class="w-7 h-7 rounded-full bg-secondary border border-border flex items-center justify-center shrink-0">
            <span class="text-[10px] font-semibold text-muted-foreground uppercase">
              {member.Name.charAt(0)}
            </span>
          </div>

          <!-- Info -->
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-foreground truncate leading-tight">{member.Name}</p>
            <p class="text-[10px] tracking-wider text-muted-foreground uppercase">
              {member.IsLeader ? 'Leader' : 'Member'}
            </p>
          </div>

          <!-- Status dot -->
          <div class="w-1.5 h-1.5 rounded-full bg-status-online shrink-0"></div>
        </div>
      {/each}
    </div>

    <!-- Actions -->
    <div class="flex flex-col gap-2">
      {#if isLeader}
        <button class="btn-neutral w-full flex items-center justify-center gap-2" onclick={toggleInvite}>
          <UserPlus size={13} />
          Invite
        </button>

        <!-- Invite input -->
        <div
          class="overflow-hidden transition-all duration-200 ease-out {showInvite ? 'max-h-20 opacity-100' : 'max-h-0 opacity-0'}"
        >
          <div class="flex gap-1.5 pt-0.5">
            <input
              bind:this={inviteInput}
              bind:value={inviteId}
              onkeydown={onInviteKeydown}
              type="number"
              min="1"
              placeholder="Server ID"
              class="flex-1 min-w-0 bg-secondary border border-border rounded px-2.5 py-1.5 text-xs text-foreground placeholder:text-muted-foreground outline-none focus:border-primary transition-colors [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
            />
            <button
              onclick={SendInvite}
              class="shrink-0 p-1.5 rounded bg-primary hover:brightness-110 transition-all flex items-center justify-center"
              title="Send invite"
            >
              <Send size={13} class="text-primary-foreground" />
            </button>
            <button
              onclick={toggleInvite}
              class="shrink-0 p-1.5 rounded bg-secondary border border-border hover:bg-destructive/20 hover:border-destructive/50 transition-all flex items-center justify-center"
              title="Cancel"
            >
              <X size={13} class="text-muted-foreground" />
            </button>
          </div>
        </div>

        <button class="btn-outline-danger w-full flex items-center justify-center gap-2" onclick={DisbandTeam}>
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
  {/if}
</div>
