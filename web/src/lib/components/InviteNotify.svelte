<script lang="ts">
  import { Users } from '@lucide/svelte';
  import { useNuiEvent } from '$lib/utils/useNuiEvent';

  interface InviteData {
    Name: string;
  }

  let visible = $state(false);
  let closing = $state(false);
  let inviterName = $state('');

  let timeoutId: ReturnType<typeof setTimeout> | null = null;
  let barKey = $state(0); // bump to restart the CSS animation

  function show(data: InviteData) {
    if (timeoutId) clearTimeout(timeoutId);
    closing = false;
    visible = true;
    inviterName = data.Name;
    barKey++;

    timeoutId = setTimeout(hide, 30_000);
  }

  function hide() {
    if (!visible) return;
    closing = true;
    if (timeoutId) { clearTimeout(timeoutId); timeoutId = null; }
    setTimeout(() => { visible = false; closing = false; }, 220);
  }

  useNuiEvent<InviteData>('ShowInvite', show);
  useNuiEvent('HideInvite', hide);
</script>

{#if visible}
  <div class="fixed top-8 left-175 z-[9999] {closing ? 'animate-slide-down' : 'animate-slide-up'}">
    <div class="panel overflow-hidden w-80 shadow-2xl">
      <!-- Header -->
      <div class="flex items-center gap-2.5 px-4 py-3 border-b border-border bg-card">
        <Users size={14} class="text-primary shrink-0" />
        <span class="text-xs font-semibold tracking-widest uppercase text-text-bright">
          Team Invite
        </span>
      </div>

      <!-- Body -->
      <div class="px-4 py-3 bg-card">
        <p class="text-sm text-foreground leading-snug">
          <span class="font-semibold text-text-bright">{inviterName}</span>
          <span class="text-secondary-foreground"> wants you to join their team</span>
        </p>

        <!-- Key hints -->
        <div class="flex items-center justify-between mt-3">
          <div class="flex items-center gap-2">
            <kbd class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-medium tracking-wide border border-border bg-secondary text-destructive">
              F5
            </kbd>
            <span class="text-[11px] text-muted-foreground uppercase tracking-wide">Deny</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-[11px] text-muted-foreground uppercase tracking-wide">Accept</span>
            <kbd class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-medium tracking-wide border border-border bg-secondary text-status-online">
              F6
            </kbd>
          </div>
        </div>
      </div>

      <!-- Countdown bar -->
      {#key barKey}
        <div class="h-[2px] bg-secondary">
          <div class="h-full bg-primary animate-countdown origin-left"></div>
        </div>
      {/key}
    </div>
  </div>
{/if}
