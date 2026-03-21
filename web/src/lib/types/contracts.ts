export type ContractDifficulty = 'Easy' | 'Medium' | 'Hard' | 'Extreme';
export type ContractState = 'available' | 'active' | 'locked';

export interface Contract {
  Id: number;
  Label: string;
  Description: string;
  Image: string;
  Difficulty: ContractDifficulty;
  RequiredLevel: number;
  OneTime: boolean;
  Requirements: string[];
  InProgress: boolean;
  Removed ?: boolean;
}

export interface TeamMember {
  Name: string;
  IsLeader: boolean;
  Source: number;
}

export interface PlayerData {
  xp: number;
  level: number;
  nextLevelXP: number;
  team: TeamMember[];
  contracts: Contract[];
}

export interface Config {
  MaxTeamSize: number;
}