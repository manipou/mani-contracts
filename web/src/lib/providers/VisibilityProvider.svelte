<script lang="ts">
	import { visibilityStore as Visible } from "$lib/stores/VisibilityStore";
	import { fetchNui } from "$lib/utils/fetchNui";

	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	function handleKeydown(e: KeyboardEvent) {
		if (e.key === 'Escape' && $Visible) {
			Visible.hide();
			fetchNui('HideUi');
		}
	}
</script>

<svelte:window onkeydown={handleKeydown} />

{#if $Visible}
	{@render children?.()}
{/if}