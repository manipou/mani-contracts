export type ContractDifficulty = 'Easy' | 'Medium' | 'Hard' | 'Extreme';
export type ContractState = 'available' | 'active' | 'locked';

export interface Contract {
  id: string;
  label: string;
  description: string;
  image: string;
  payout: string;
  difficulty: ContractDifficulty;
  requiredXP: number;
  requiredLevel: number;
  single: boolean;
  active: boolean;
}

export interface TeamMember {
  name: string;
  leader: boolean;
  avatar?: string;
}

export interface PlayerData {
  xp: number;
  level: number;
  nextLevelXP: number;
  team: TeamMember[];
  contracts: Contract[];
}
