export type ContractDifficulty = 'Easy' | 'Medium' | 'Hard' | 'Extreme';
export type ContractState = 'available' | 'active' | 'locked';

export interface Contract {
  id: string;
  Label: string;
  Description: string;
  Image: string;
  Difficulty: ContractDifficulty;
  RequiredLevel: number;
  OneTime: boolean;
  Requirements: string[];
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