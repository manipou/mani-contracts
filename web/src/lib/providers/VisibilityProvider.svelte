<script lang="ts">
	import { visibilityStore as Visible } from "$lib/stores/VisibilityStore";
	import { useNuiEvent } from "$lib/utils/useNuiEvent";

	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	useNuiEvent("OpenMenu", () => {
		Visible.show();
	});
</script>

{#if $Visible}
	{@render children?.()}
{/if}